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

    init(
        remoteDataSource: some TVListingsRemoteDataSource,
        localDataSource: some TVListingsLocalDataSource,
        syncThrottle: TimeInterval = 12 * 60 * 60,
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.syncThrottle = syncThrottle
        self.now = now
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

        for date in manifest.dates {
            try await syncScheduleIfChanged(date: date, manifest: manifest, stored: stored)
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

    private func syncScheduleIfChanged(
        date: String,
        manifest: EPGManifest,
        stored: [String: String]
    ) async throws(TVListingsRepositoryError) {
        // Skip unchanged days entirely — no fetch, no write. This is the performance win.
        guard let file = manifest.scheduleFile(forDate: date), stored[file.path] != file.hash else {
            return
        }

        let programmes: [TVProgramme]
        do {
            programmes = try await remoteDataSource.fetchSchedule(forDate: date)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }

        do {
            try await localDataSource.replaceProgrammes(programmes, forDate: date, hash: file.hash)
        } catch let error {
            throw TVListingsRepositoryError(error)
        }
    }

}
