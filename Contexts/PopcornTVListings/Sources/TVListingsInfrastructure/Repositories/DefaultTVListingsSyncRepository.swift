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

    func sync() async throws(TVListingsRepositoryError) {
        do {
            try await coalescedSync()
        } catch let error as TVListingsRepositoryError {
            throw error
        } catch {
            throw .unknown(error)
        }
    }

    func syncIfNeeded() async throws(TVListingsRepositoryError) {
        let lastSyncedAt: Date?
        do {
            lastSyncedAt = try await localDataSource.lastSyncedAt()
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        if let lastSyncedAt, now().timeIntervalSince(lastSyncedAt) < syncThrottle {
            return
        }

        try await sync()
    }

    // MARK: - Coalescing

    private func coalescedSync() async throws {
        if let inFlight {
            onCoalesce?()
            try await inFlight.value
            return
        }

        // No `await` between the nil-check above and this assignment, so only one caller ever
        // becomes the task starter; reentrant callers take the branch above and coalesce.
        let task = Task<Void, any Error> { [self] in
            try await performSync()
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

    private func performSync() async throws(TVListingsRepositoryError) {
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

        try await syncChannelsIfChanged(manifest: manifest, stored: stored)

        try await syncRegionsIfChanged(manifest: manifest, stored: stored)

        try await syncChangedSchedules(manifest: manifest, stored: stored)

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
    }

    private func syncChannelsIfChanged(
        manifest: EPGManifest,
        stored: [String: String]
    ) async throws(TVListingsRepositoryError) {
        guard let file = manifest.channelsFile, stored[file.path] != file.hash else {
            return
        }

        let channels: [TVChannel]
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
    /// Fetches and persists every changed day's schedule concurrently. Unchanged days are
    /// skipped entirely (no fetch, no write) — the hash-skip is the performance win, and the
    /// fan-out cuts a cold-launch (up to 7 changed days) to roughly one round-trip's latency.
    /// Fetches run in parallel; the per-day writes serialise on the local data-source actor and
    /// each commits its day + hash atomically. A failure cancels the rest and propagates, so the
    /// later purge/`completeSync` never runs — leaving the cache with more data, never less.
    ///
    private func syncChangedSchedules(
        manifest: EPGManifest,
        stored: [String: String]
    ) async throws(TVListingsRepositoryError) {
        let changedDays: [(date: String, hash: String)] = manifest.dates.compactMap { date in
            // Validate the manifest-supplied date before it reaches a URL path. Skips any
            // malformed entry so a bad feed value can't produce a traversal/odd request.
            guard Self.isValidDateString(date),
                  let file = manifest.scheduleFile(forDate: date),
                  stored[file.path] != file.hash
            else {
                return nil
            }
            return (date, file.hash)
        }

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
                try await group.waitForAll()
            }
        } catch let error as TVListingsRemoteDataSourceError {
            throw TVListingsRepositoryError(error)
        } catch let error as TVListingsLocalDataSourceError {
            throw TVListingsRepositoryError(error)
        } catch {
            throw .unknown(error)
        }
    }

    /// `true` when the string is a bare `yyyyMMdd` (8 digits) — the only shape the feed
    /// produces and the only shape safe to interpolate into a request path.
    private static func isValidDateString(_ date: String) -> Bool {
        date.count == 8 && date.allSatisfy(\.isNumber)
    }

}
