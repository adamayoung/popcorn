//
//  SwiftDataTVListingsLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import SwiftData
import TVListingsDomain

@ModelActor
actor SwiftDataTVListingsLocalDataSource: TVListingsLocalDataSource {

    private static let logger = Logger.tvListingsInfrastructure

    private static let ukTimeZone = TimeZone(identifier: "Europe/London")

    func channels() async throws(TVListingsLocalDataSourceError) -> [TVChannel] {
        let descriptor = FetchDescriptor<TVChannelEntity>(
            sortBy: [SortDescriptor(\.name)]
        )

        let entities: [TVChannelEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVChannelEntityMapper()
        return entities.map(mapper.map)
    }

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        let range = dayRange(for: date)
        let dayStart = range.start
        let dayEnd = range.end

        let predicate = #Predicate<TVProgrammeEntity> { entity in
            entity.channelID == channelID
                && entity.startTime >= dayStart
                && entity.startTime < dayEnd
        }

        var descriptor = FetchDescriptor<TVProgrammeEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.startTime)]
        )
        descriptor.relationshipKeyPathsForPrefetching = []

        let entities: [TVProgrammeEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVProgrammeEntityMapper()
        return entities.map(mapper.map)
    }

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        let predicate = #Predicate<TVProgrammeEntity> { entity in
            entity.startTime <= date && entity.endTime > date
        }

        var descriptor = FetchDescriptor<TVProgrammeEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.channelID)]
        )
        descriptor.relationshipKeyPathsForPrefetching = []

        let entities: [TVProgrammeEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = TVProgrammeEntityMapper()
        return entities.map(mapper.map)
    }

    ///
    /// Replaces the cache with the given channels and programmes.
    ///
    /// Writes are committed in a single transaction so a `save()` failure rolls
    /// back any staged inserts. The batch-delete of existing rows runs against
    /// the persistent store directly; if the subsequent insert save fails, the
    /// store may be left empty — never partially populated. A subsequent
    /// successful sync will re-populate it.
    ///
    func replaceAll(
        channels: [TVChannel],
        programmes: [TVProgramme]
    ) async throws(TVListingsLocalDataSourceError) {
        do {
            try modelContext.delete(model: TVProgrammeEntity.self)
            try modelContext.delete(model: TVChannelNumberEntity.self)
            try modelContext.delete(model: TVChannelEntity.self)

            let channelMapper = TVChannelEntityMapper()
            for channel in channels {
                modelContext.insert(channelMapper.map(channel))
            }

            let programmeMapper = TVProgrammeEntityMapper()
            for programme in programmes {
                modelContext.insert(programmeMapper.map(programme))
            }

            try modelContext.save()
        } catch let error {
            modelContext.rollback()
            throw .persistence(error)
        }
    }

    private func dayRange(for date: Date) -> (start: Date, end: Date) {
        var calendar = Calendar(identifier: .gregorian)
        if let timeZone = Self.ukTimeZone {
            calendar.timeZone = timeZone
        }
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start.addingTimeInterval(86400)
        return (start, end)
    }

}
