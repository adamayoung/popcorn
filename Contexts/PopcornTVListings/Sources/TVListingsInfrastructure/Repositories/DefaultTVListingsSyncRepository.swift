//
//  DefaultTVListingsSyncRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

///
/// Orchestrates the incremental, content-addressed EPG sync: fetches the manifest, downloads
/// only the files whose hash changed, drops days no longer in the feed, and stamps the last
/// sync time. Implemented as an `actor` with an in-flight guard so overlapping triggers
/// (app launch + foreground) coalesce onto a single network sequence.
///
actor DefaultTVListingsSyncRepository: TVListingsSyncRepository {

    private let remoteDataSource: any TVListingsRemoteDataSource
    private let localDataSource: any TVListingsLocalDataSource
    private let syncThrottle: TimeInterval
    private let now: @Sendable () -> Date

    /// The currently-running sync, if any. Reused by overlapping callers so they coalesce.
    private var inFlight: Task<Void, any Error>?

    /// Optional observation point fired when a caller takes the coalescing branch. `nil` in
    /// production; a test sets it to observe coalescing deterministically without relying on
    /// scheduler timing.
    private let onCoalesce: (@Sendable () -> Void)?

    init(
        remoteDataSource: some TVListingsRemoteDataSource,
        localDataSource: some TVListingsLocalDataSource,
        syncThrottle: TimeInterval = 12 * 60 * 60,
        now: @escaping @Sendable () -> Date = { .now },
        onCoalesce: (@Sendable () -> Void)? = nil
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.syncThrottle = syncThrottle
        self.now = now
        self.onCoalesce = onCoalesce
    }

    /// Unconditional sync without progress observation.
    func sync() async throws(TVListingsRepositoryError) {
        try await sync { _ in }
    }

    func sync(onProgress: @Sendable @escaping (Float) -> Void) async throws(TVListingsRepositoryError) {
        do {
            try await coalescedSync(onProgress: onProgress)
        } catch let error as TVListingsRepositoryError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }

    func syncIfNeeded(onProgress: @Sendable @escaping (Float) -> Void) async throws(TVListingsRepositoryError) {
        let lastSyncedAt: Date?
        do {
            lastSyncedAt = try await localDataSource.lastSyncedAt()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        if let lastSyncedAt, now().timeIntervalSince(lastSyncedAt) < syncThrottle, await isCachePopulated() {
            return
        }

        try await sync(onProgress: onProgress)
    }

    /// Whether the cache actually holds the data a completed sync should have produced. A
    /// SwiftData lightweight migration can recreate a renamed/added table empty while
    /// preserving `lastSyncedAt`; treating that as "synced" would let the throttle suppress
    /// the re-sync and leave the screen empty (channels) or the region filter inert (regions)
    /// until the window expired. A read failure here is treated as "not populated" so we
    /// re-sync rather than abort the throttle decision.
    private func isCachePopulated() async -> Bool {
        do {
            guard try await !localDataSource.channels().isEmpty else {
                return false
            }
            // Regions are only "expected" once `regions.json` has been synced before, so a feed
            // that never delivers it doesn't force a sync on every launch.
            let regionsExpected = try await localDataSource.fileStates().keys.contains("regions.json")
            if regionsExpected, try await localDataSource.regions().isEmpty {
                return false
            }
            return true
        } catch {
            return false
        }
    }

    // MARK: - Coalescing

    private func coalescedSync(onProgress: @Sendable @escaping (Float) -> Void) async throws {
        if let inFlight {
            onCoalesce?()
            try await inFlight.value
            return
        }

        // No `await` between the nil-check above and this assignment, so only one caller ever
        // becomes the task starter; reentrant callers take the branch above and coalesce. The
        // starter's `onProgress` is baked into the in-flight task, so coalescing callers
        // (which await `inFlight.value` above) never receive progress — only the starter does.
        let task = Task<Void, any Error> { [self] in
            try await performSync(onProgress: onProgress)
        }
        inFlight = task

        do {
            try await task.value
            inFlight = nil
        } catch {
            inFlight = nil
            throw error
        }
    }

    // MARK: - Orchestration

    private func performSync(
        onProgress: @Sendable @escaping (Float) -> Void
    ) async throws(TVListingsRepositoryError) {
        // A failed manifest fetch throws before any local mutation, so the cache is never
        // wiped on a network failure.
        let manifest: EPGManifest
        do {
            manifest = try await remoteDataSource.fetchManifest()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        let stored: [String: String]
        do {
            stored = try await localDataSource.fileStates()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        // Progress is weighted by the files we will download. The manifest (already fetched)
        // counts as one unit so the bar leaves 0% immediately rather than stalling there while
        // the channel/region/day files come down. `total` is always >= 1, so no divide-by-zero.
        let channelsChanged = manifest.channelsFile.map { stored[$0.path] != $0.hash } ?? false
        let regionsChanged = manifest.regionsFile.map { stored[$0.path] != $0.hash } ?? false
        let changedDays = Self.changedDays(manifest: manifest, stored: stored)
        let total = 1 + (channelsChanged ? 1 : 0) + (regionsChanged ? 1 : 0) + changedDays.count
        var completed = 1
        onProgress(Float(completed) / Float(total))

        try await syncChannelsIfChanged(manifest: manifest, stored: stored)
        if channelsChanged {
            completed += 1
            onProgress(Float(completed) / Float(total))
        }

        try await syncRegionsIfChanged(manifest: manifest, stored: stored)
        if regionsChanged {
            completed += 1
            onProgress(Float(completed) / Float(total))
        }

        // The `for try await … in group` loop body runs on this actor's executor, so mutating
        // `completed` and calling `onProgress` from it is race-free.
        try await syncSchedules(changedDays) {
            completed += 1
            onProgress(Float(completed) / Float(total))
        }

        // Purge whole past days and any day no longer in the rolling window. Today is retained
        // in full. Runs only after the day loop, so a partial sync leaves more data, never less.
        do {
            try await localDataSource.deleteProgrammes(notInDates: manifest.dates)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        let validPaths = Set(manifest.files.map(\.path))
        do {
            try await localDataSource.completeSync(
                lastSyncedAt: now(),
                keepingFileStatePaths: validPaths
            )
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        // Every unit completing already emits `completed / total == 1.0`, so only emit the
        // terminal value if something left the weighted sum short (defensive against drift).
        if completed < total {
            onProgress(1)
        }
    }

    private func syncChannelsIfChanged(
        manifest: EPGManifest,
        stored: [String: String]
    ) async throws(TVListingsRepositoryError) {
        guard let file = manifest.channelsFile, stored[file.path] != file.hash else {
            return
        }

        let channels: [Channel]
        do {
            channels = try await remoteDataSource.fetchChannels()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        do {
            try await localDataSource.upsertChannels(channels, hash: file.hash)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

    private func syncRegionsIfChanged(
        manifest: EPGManifest,
        stored: [String: String]
    ) async throws(TVListingsRepositoryError) {
        guard let file = manifest.regionsFile, stored[file.path] != file.hash else {
            return
        }

        let regions: [TVRegion]
        do {
            regions = try await remoteDataSource.fetchRegions()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        do {
            try await localDataSource.upsertRegions(regions, hash: file.hash)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

    ///
    /// Fetches and persists the already-filtered `changedDays` concurrently (the changed-day
    /// computation and date validation live in ``changedDays(manifest:stored:)``). The fan-out
    /// cuts a cold-launch (up to 7 changed days) to roughly one round-trip's latency. Fetches
    /// run in parallel; the per-day writes serialise on the local data-source actor and each
    /// commits its day + hash atomically. `onDayComplete` is called on this actor as each day
    /// finishes (arbitrary order), for progress reporting. A failure cancels the rest and
    /// propagates, so the later purge/`completeSync` never runs — leaving the cache with more
    /// data, never less.
    ///
    private func syncSchedules(
        _ changedDays: [(date: String, hash: String)],
        onDayComplete: () -> Void
    ) async throws(TVListingsRepositoryError) {
        guard !changedDays.isEmpty else {
            return
        }

        let remote = remoteDataSource
        let local = localDataSource
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for day in changedDays {
                    group.addTask {
                        let programmes = try await remote.fetchSchedule(forDate: day.date)
                        try await local.replaceProgrammes(programmes, forDate: day.date, hash: day.hash)
                    }
                }
                // Drain as each day finishes (arbitrary order) so progress reflects files
                // completed. The loop body runs on this actor, so `onDayComplete` is safe.
                for try await _ in group {
                    onDayComplete()
                }
            }
        } catch let error as TVListingsRemoteDataSourceError {
            throw TVListingsRepositoryError(error)
        } catch let error as TVListingsLocalDataSourceError {
            throw TVListingsRepositoryError(error)
        } catch {
            throw .unknown(error)
        }
    }

    /// The changed schedule days from `manifest` (hash differs from `stored`), with malformed
    /// dates skipped so a bad feed value can't reach a URL path. Computed up front so the
    /// caller knows the count for progress weighting.
    private static func changedDays(
        manifest: EPGManifest,
        stored: [String: String]
    ) -> [(date: String, hash: String)] {
        manifest.dates.compactMap { date in
            guard Self.isValidDateString(date),
                  let file = manifest.scheduleFile(forDate: date),
                  stored[file.path] != file.hash
            else {
                return nil
            }
            return (date, file.hash)
        }
    }

    /// `true` when the string is a bare `yyyyMMdd` (8 digits) — the only shape the feed
    /// produces and the only shape safe to interpolate into a request path.
    private static func isValidDateString(_ date: String) -> Bool {
        date.count == 8 && date.allSatisfy(\.isNumber)
    }

}
