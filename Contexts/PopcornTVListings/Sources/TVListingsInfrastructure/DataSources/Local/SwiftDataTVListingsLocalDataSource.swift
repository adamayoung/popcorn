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

actor SwiftDataTVListingsLocalDataSource: TVListingsLocalDataSource, ModelActor {

    private static let logger = Logger.tvListingsInfrastructure

    nonisolated let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    private let calendar: Calendar

    init(modelContainer: ModelContainer, calendar: Calendar = .ukGregorian) {
        let modelContext = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
        self.calendar = calendar
    }

    func channels() async throws(TVListingsLocalDataSourceError) -> [TVChannel] {
        let channelDescriptor = FetchDescriptor<TVChannelEntity>(
            sortBy: [SortDescriptor(\.name)]
        )

        let channelEntities: [TVChannelEntity]
        let numberEntities: [TVChannelNumberEntity]
        do {
            channelEntities = try modelContext.fetch(channelDescriptor)
            numberEntities = try modelContext.fetch(FetchDescriptor<TVChannelNumberEntity>())
        } catch let error {
            throw .persistence(error)
        }

        let numbersByChannel = Dictionary(grouping: numberEntities, by: \.channelID)
        let mapper = TVChannelEntityMapper()
        return channelEntities.map { channel in
            mapper.map(channel, numbers: numbersByChannel[channel.channelID] ?? [])
        }
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
                for number in channelMapper.mapNumbers(for: channel) {
                    modelContext.insert(number)
                }
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
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start.addingTimeInterval(86400)
        return (start, end)
    }

}
