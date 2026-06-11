//
//  TVListingsLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

public protocol TVListingsLocalDataSource: Actor {

    // MARK: - Reads

    func channels() async throws(TVListingsLocalDataSourceError) -> [TVChannel]

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme]

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme]

    // MARK: - Sync state

    /// The locally-stored content hash of every known EPG file, keyed by path.
    func fileStates() async throws(TVListingsLocalDataSourceError) -> [String: String]

    /// When the cache was last successfully synced, or `nil` if never.
    func lastSyncedAt() async throws(TVListingsLocalDataSourceError) -> Date?

    // MARK: - Writes

    /// Replaces the channel directory and records the `channels.json` content hash in the
    /// same transaction.
    func upsertChannels(
        _ channels: [TVChannel],
        hash: String
    ) async throws(TVListingsLocalDataSourceError)

    /// Replaces a single UK day's programmes (matched by start time falling in that day) and
    /// records the day's `schedules/<date>.json` content hash in the same transaction.
    func replaceProgrammes(
        _ programmes: [TVProgramme],
        forDate date: String,
        hash: String
    ) async throws(TVListingsLocalDataSourceError)

    /// Deletes every programme that does not fall within one of the given `yyyyMMdd` days.
    /// Used to drop past days and days no longer in the feed's rolling window.
    func deleteProgrammes(
        notInDates dates: [String]
    ) async throws(TVListingsLocalDataSourceError)

    /// Records a successful sync: stamps `lastSyncedAt` and prunes file-state rows whose path
    /// is no longer present in the manifest.
    func completeSync(
        lastSyncedAt date: Date,
        keepingFileStatePaths paths: Set<String>
    ) async throws(TVListingsLocalDataSourceError)

}

public enum TVListingsLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
