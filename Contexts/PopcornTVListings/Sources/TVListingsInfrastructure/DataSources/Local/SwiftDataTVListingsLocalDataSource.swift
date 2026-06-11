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

    static let logger = Logger.tvListingsInfrastructure

    nonisolated let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    let calendar: Calendar

    /// Parses a `yyyyMMdd` schedule-file date in the UK time zone, so day buckets are stable
    /// regardless of the device time zone.
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Europe/London")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()

    init(modelContainer: ModelContainer, calendar: Calendar = .ukGregorian) {
        let modelContext = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
        self.calendar = calendar
    }

    // MARK: - Reads

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
                && entity.startTime < dayEnd
                && entity.endTime > dayStart
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

        var descriptor = FetchDescriptor<TVProgrammeEntity>(predicate: predicate)
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

    func programmes(
        from: Date,
        to: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        let lowerBound = from
        let upperBound = to

        let predicate = #Predicate<TVProgrammeEntity> { entity in
            entity.endTime > lowerBound && entity.startTime < upperBound
        }

        var descriptor = FetchDescriptor<TVProgrammeEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.channelID), SortDescriptor(\.startTime)]
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

    // MARK: - Sync state reads

    func fileStates() async throws(TVListingsLocalDataSourceError) -> [String: String] {
        let entities: [EPGFileStateEntity]
        do {
            entities = try modelContext.fetch(FetchDescriptor<EPGFileStateEntity>())
        } catch let error {
            throw .persistence(error)
        }

        return Dictionary(
            entities.map { ($0.path, $0.contentHash) },
            uniquingKeysWith: { _, latest in latest }
        )
    }

    func lastSyncedAt() async throws(TVListingsLocalDataSourceError) -> Date? {
        do {
            return try modelContext.fetch(FetchDescriptor<EPGSyncStateEntity>()).first?.lastSyncedAt
        } catch let error {
            throw .persistence(error)
        }
    }

    // MARK: - Day ranges

    func dayRange(for date: Date) -> (start: Date, end: Date) {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start.addingTimeInterval(86400)
        return (start, end)
    }

    /// The `[start, end)` UK-day range for a `yyyyMMdd` string, or `nil` if it can't be parsed.
    func dayRange(forDateString dateString: String) -> (start: Date, end: Date)? {
        guard let day = Self.dayFormatter.date(from: dateString) else {
            return nil
        }
        return dayRange(for: day)
    }

}
