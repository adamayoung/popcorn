//
//  SwiftDataTVListingsLocalDataSourceTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("SwiftDataTVListingsLocalDataSource")
struct SwiftDataTVListingsLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        let schema = Schema([
            TVChannelEntity.self,
            TVChannelNumberEntity.self,
            TVProgrammeEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - channels() Tests

    @Test("channels returns empty when the cache is empty")
    func channelsReturnsEmptyWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.channels()

        #expect(result.isEmpty)
    }

    @Test("channels returns inserted channels after replaceAll")
    func channelsReturnsInsertedChannelsAfterReplaceAll() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let channels = [TVChannel.mock(id: "BBC", name: "BBC"), TVChannel.mock(id: "ITV", name: "ITV")]

        try await dataSource.replaceAll(channels: channels, programmes: [])
        let result = try await dataSource.channels()

        #expect(result.count == 2)
        #expect(Set(result.map(\.id)) == Set(["BBC", "ITV"]))
    }

    @Test("channels preserves channel numbers")
    func channelsPreservesChannelNumbers() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let channel = TVChannel.mock(
            id: "BBC",
            name: "BBC",
            channelNumbers: [TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])]
        )

        try await dataSource.replaceAll(channels: [channel], programmes: [])
        let result = try await dataSource.channels()

        #expect(result.first?.channelNumbers.count == 1)
        #expect(result.first?.channelNumbers.first?.channelNumber == "101")
        #expect(result.first?.channelNumbers.first?.subbouquetIDs == [1, 4])
    }

    // MARK: - replaceAll() wipe-and-replace Tests

    @Test("replaceAll wipes previously inserted channels")
    func replaceAllWipesPreviouslyInsertedChannels() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "OLD", name: "Old")],
            programmes: []
        )
        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "NEW", name: "New")],
            programmes: []
        )
        let result = try await dataSource.channels()

        #expect(result.count == 1)
        #expect(result.first?.id == "NEW")
    }

    @Test("replaceAll wipes previously inserted channel numbers when re-seeded with different channels")
    func replaceAllWipesPreviouslyInsertedChannelNumbers() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        // Seed a channel carrying numbers — exercising the batch-delete path that
        // previously tripped a "mandatory nullify inverse" constraint when the child
        // entity declared an inverse to the parent.
        try await dataSource.replaceAll(
            channels: [
                TVChannel.mock(
                    id: "OLD",
                    name: "Old",
                    channelNumbers: [
                        TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 2])
                    ]
                )
            ],
            programmes: []
        )

        try await dataSource.replaceAll(
            channels: [
                TVChannel.mock(
                    id: "NEW",
                    name: "New",
                    channelNumbers: [
                        TVChannelNumber(channelNumber: "202", subbouquetIDs: [3])
                    ]
                )
            ],
            programmes: []
        )

        let channels = try await dataSource.channels()
        #expect(channels.count == 1)
        #expect(channels.first?.id == "NEW")
        #expect(channels.first?.channelNumbers.map(\.channelNumber) == ["202"])
    }

    @Test("replaceAll wipes previously inserted programmes")
    func replaceAllWipesPreviouslyInsertedProgrammes() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let start = Date(timeIntervalSince1970: 1_776_463_200)

        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "BBC")],
            programmes: [TVProgramme.mock(channelID: "BBC", start: start)]
        )
        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "BBC")],
            programmes: []
        )
        let result = try await dataSource.nowPlayingProgrammes(at: start.addingTimeInterval(60))

        #expect(result.isEmpty)
    }

    @Test("replaceAll persists all programmes for a large input")
    func replaceAllPersistsAllProgrammesForLargeInput() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        // 2026-04-18 12:00 in Europe/London — anchor inside a single calendar day
        // so consecutive-second programmes all fall on the same UK day.
        let base = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let programmes = (0 ..< 2500).map { index in
            TVProgramme.mock(
                channelID: "BBC",
                start: base.addingTimeInterval(TimeInterval(index)),
                duration: 1
            )
        }

        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "BBC")],
            programmes: programmes
        )

        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: base)
        #expect(result.count == 2500)
    }

    // MARK: - programmes(forChannelID:onDate:) Tests

    @Test("programmes filters by channel")
    func programmesFiltersByChannel() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let start = ukDate(year: 2026, month: 4, day: 18, hour: 10)

        try await dataSource.replaceAll(
            channels: [],
            programmes: [
                TVProgramme.mock(channelID: "BBC", start: start),
                TVProgramme.mock(channelID: "ITV", start: start)
            ]
        )

        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: start)

        #expect(result.count == 1)
        #expect(result.first?.channelID == "BBC")
    }

    @Test("programmes clamps to the Europe/London calendar day")
    func programmesClampsToEuropeLondonDay() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        // 2026-04-18 during BST (UTC+1). Midnight Europe/London = 2026-04-17 23:00 UTC.
        let insideDayStart = ukDate(year: 2026, month: 4, day: 18, hour: 0, minute: 30)
        let insideDayMidday = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let nextDay = ukDate(year: 2026, month: 4, day: 19, hour: 0, minute: 30)
        let previousDay = ukDate(year: 2026, month: 4, day: 17, hour: 22)

        try await dataSource.replaceAll(
            channels: [],
            programmes: [
                TVProgramme.mock(channelID: "BBC", start: insideDayStart, title: "inside-start"),
                TVProgramme.mock(channelID: "BBC", start: insideDayMidday, title: "inside-midday"),
                TVProgramme.mock(channelID: "BBC", start: nextDay, title: "next-day"),
                TVProgramme.mock(channelID: "BBC", start: previousDay, title: "previous-day")
            ]
        )

        let noonOfTheDay = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: noonOfTheDay)

        #expect(result.count == 2)
        #expect(Set(result.map(\.title)) == Set(["inside-start", "inside-midday"]))
    }

    @Test("programmes includes a late-night show that runs across midnight into the requested day")
    func programmesIncludesShowRunningAcrossMidnight() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        // Programme starts 2026-04-17 23:30 BST, runs 90 minutes — i.e. ends 2026-04-18 01:00 BST.
        let lateNightStart = ukDate(year: 2026, month: 4, day: 17, hour: 23, minute: 30)
        try await dataSource.replaceAll(
            channels: [],
            programmes: [
                TVProgramme.mock(
                    channelID: "BBC",
                    start: lateNightStart,
                    duration: 5400,
                    title: "across-midnight"
                )
            ]
        )

        let nextDayMidday = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: nextDayMidday)

        #expect(result.map(\.title) == ["across-midnight"])
    }

    @Test("programmes are returned in ascending start-time order")
    func programmesAreReturnedInAscendingStartTimeOrder() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let baseStart = ukDate(year: 2026, month: 4, day: 18, hour: 10)

        try await dataSource.replaceAll(
            channels: [],
            programmes: [
                TVProgramme.mock(channelID: "BBC", start: baseStart.addingTimeInterval(3600), title: "later"),
                TVProgramme.mock(channelID: "BBC", start: baseStart, title: "earlier")
            ]
        )

        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: baseStart)

        #expect(result.map(\.title) == ["earlier", "later"])
    }

    // MARK: - nowPlayingProgrammes(at:) Tests

    @Test("nowPlaying returns programmes currently airing")
    func nowPlayingReturnsProgrammesCurrentlyAiring() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let now = Date(timeIntervalSince1970: 1_776_463_200)

        try await dataSource.replaceAll(
            channels: [],
            programmes: [
                TVProgramme.mock(
                    channelID: "BBC",
                    start: now.addingTimeInterval(-600),
                    duration: 1800,
                    title: "on-now"
                ),
                TVProgramme.mock(channelID: "BBC", start: now.addingTimeInterval(3600), duration: 1800, title: "later"),
                TVProgramme.mock(
                    channelID: "BBC",
                    start: now.addingTimeInterval(-7200),
                    duration: 1800,
                    title: "earlier"
                )
            ]
        )

        let result = try await dataSource.nowPlayingProgrammes(at: now)

        #expect(result.count == 1)
        #expect(result.first?.title == "on-now")
    }

    @Test("nowPlaying excludes programmes whose endTime equals now")
    func nowPlayingExcludesProgrammesEndingAtNow() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let now = Date(timeIntervalSince1970: 1_776_463_200)

        try await dataSource.replaceAll(
            channels: [],
            programmes: [
                TVProgramme.mock(
                    channelID: "BBC",
                    start: now.addingTimeInterval(-1800),
                    duration: 1800,
                    title: "just-ended"
                )
            ]
        )

        let result = try await dataSource.nowPlayingProgrammes(at: now)

        #expect(result.isEmpty)
    }

    // MARK: - Helpers

    private func ukDate(year: Int, month: Int, day: Int, hour: Int, minute: Int = 0) -> Date {
        guard let timeZone = TimeZone(identifier: "Europe/London") else {
            return .distantPast
        }
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.timeZone = timeZone
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.date(from: components) ?? .distantPast
    }

}
