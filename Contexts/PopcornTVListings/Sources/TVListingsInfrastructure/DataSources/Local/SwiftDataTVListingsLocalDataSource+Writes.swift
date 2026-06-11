//
//  SwiftDataTVListingsLocalDataSource+Writes.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import TVListingsDomain

extension SwiftDataTVListingsLocalDataSource {

    ///
    /// Replaces the whole channel directory and records the `channels.json` hash in one
    /// transaction. Channels are small and only rewritten when their file hash changes, so a
    /// wholesale replace is simplest and leaves no orphaned channel-number rows.
    ///
    /// The `delete(model:)` calls write directly to the persistent store, so if the subsequent
    /// `save()` of the inserts/hash fails, the deletes can't be rolled back — the channel table
    /// may be left empty and the `channels.json` hash unchanged. That's safe: the next sync sees
    /// the unchanged hash, re-fetches `channels.json`, and re-populates it.
    ///
    func upsertChannels(
        _ channels: [TVChannel],
        hash: String
    ) async throws(TVListingsLocalDataSourceError) {
        do {
            try modelContext.delete(model: TVChannelNumberEntity.self)
            try modelContext.delete(model: TVChannelEntity.self)

            let mapper = TVChannelEntityMapper()
            for channel in channels {
                modelContext.insert(mapper.map(channel))
                for number in mapper.mapNumbers(for: channel) {
                    modelContext.insert(number)
                }
            }

            try upsertFileState(path: "channels.json", hash: hash)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

    ///
    /// Replaces a single UK day's programmes and records that day's schedule-file hash in one
    /// transaction. The delete is scoped to programmes whose **start time** falls in the day
    /// (matching how the feed buckets programmes into a date file), so a programme that spills
    /// past midnight into the next day's range is never removed when an adjacent day is rewritten.
    ///
    /// As with `upsertChannels`, the batch delete writes directly to the store; a failed `save()`
    /// can leave the day empty with its hash unchanged, and the next sync re-fetches that day.
    ///
    func replaceProgrammes(
        _ programmes: [TVProgramme],
        forDate date: String,
        hash: String
    ) async throws(TVListingsLocalDataSourceError) {
        guard let range = dayRange(forDateString: date) else {
            throw .unknown(
                NSError(
                    domain: "TVListingsLocalDataSource",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid schedule date string: \(date)"]
                )
            )
        }

        let dayStart = range.start
        let dayEnd = range.end

        do {
            let predicate = #Predicate<TVProgrammeEntity> { entity in
                entity.startTime >= dayStart && entity.startTime < dayEnd
            }
            try modelContext.delete(model: TVProgrammeEntity.self, where: predicate)

            let mapper = TVProgrammeEntityMapper()
            for programme in programmes {
                modelContext.insert(mapper.map(programme))
            }

            try upsertFileState(path: "schedules/\(date).json", hash: hash)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

    ///
    /// Deletes every programme whose start time falls outside the contiguous span of the given
    /// `yyyyMMdd` days. Drops past days and any day no longer in the feed's rolling window.
    /// Assumes `dates` is a contiguous range (the feed is a contiguous rolling window): an
    /// interior gap would be retained rather than pruned. A no-op when `dates` is empty, so a
    /// degenerate empty manifest never wipes the cache.
    ///
    func deleteProgrammes(
        notInDates dates: [String]
    ) async throws(TVListingsLocalDataSourceError) {
        let ranges = dates.compactMap(dayRange(forDateString:))
        guard let earliest = ranges.map(\.start).min(),
              let latest = ranges.map(\.end).max()
        else {
            return
        }

        do {
            let predicate = #Predicate<TVProgrammeEntity> { entity in
                entity.startTime < earliest || entity.startTime >= latest
            }
            try modelContext.delete(model: TVProgrammeEntity.self, where: predicate)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

    ///
    /// Stamps `lastSyncedAt` and prunes file-state rows whose path is no longer in the manifest,
    /// committing both in one transaction.
    ///
    func completeSync(
        lastSyncedAt date: Date,
        keepingFileStatePaths paths: Set<String>
    ) async throws(TVListingsLocalDataSourceError) {
        do {
            let states = try modelContext.fetch(FetchDescriptor<EPGFileStateEntity>())
            for state in states where !paths.contains(state.path) {
                modelContext.delete(state)
            }

            let syncStates = try modelContext.fetch(FetchDescriptor<EPGSyncStateEntity>())
            if let existing = syncStates.first {
                existing.lastSyncedAt = date
            } else {
                modelContext.insert(EPGSyncStateEntity(lastSyncedAt: date))
            }

            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

    // MARK: - Helpers

    /// Inserts or updates the stored hash for a file path. Caller is responsible for `save()`.
    private func upsertFileState(path: String, hash: String) throws {
        let descriptor = FetchDescriptor<EPGFileStateEntity>(
            predicate: #Predicate { $0.path == path }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.contentHash = hash
        } else {
            modelContext.insert(EPGFileStateEntity(path: path, contentHash: hash))
        }
    }

}
