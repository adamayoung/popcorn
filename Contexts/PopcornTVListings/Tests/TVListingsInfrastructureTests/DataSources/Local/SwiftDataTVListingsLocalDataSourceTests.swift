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

@Suite("SwiftDataTVListingsLocalDataSource reads")
struct SwiftDataTVListingsLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        self.modelContainer = try TVListingsInfrastructureFactory.makeInMemoryModelContainer()
    }

    // MARK: - channels()

    @Test("channels returns empty when the cache is empty")
    func channelsReturnsEmptyWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.channels()

        #expect(result.isEmpty)
    }

    @Test("channels returns inserted channels with their numbers")
    func channelsReturnsInsertedChannelsWithNumbers() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let channel = TVChannel.mock(
            id: "BBC",
            name: "BBC",
            channelNumbers: [TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])]
        )

        try await dataSource.upsertChannels([channel], hash: "c1")
        let result = try await dataSource.channels()

        #expect(result.count == 1)
        #expect(result.first?.channelNumbers.first?.channelNumber == "101")
        #expect(result.first?.channelNumbers.first?.subbouquetIDs == [1, 4])
    }

    // MARK: - programmes(forChannelID:onDate:)

    @Test("programmes filters by channel")
    func programmesFiltersByChannel() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let start = ukDate(year: 2026, month: 4, day: 18, hour: 10)

        try await dataSource.replaceProgrammes(
            [
                TVProgramme.mock(channelID: "BBC", start: start),
                TVProgramme.mock(channelID: "ITV", start: start)
            ],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: start)

        #expect(result.count == 1)
        #expect(result.first?.channelID == "BBC")
    }

    @Test("programmes clamps to the Europe/London calendar day")
    func programmesClampsToEuropeLondonDay() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(
                channelID: "BBC",
                start: ukDate(year: 2026, month: 4, day: 17, hour: 22),
                title: "previous-day"
            )],
            forDate: "20260417",
            hash: "s0"
        )
        try await dataSource.replaceProgrammes(
            [
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 0, minute: 30),
                    title: "inside-start"
                ),
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 12),
                    title: "inside-midday"
                )
            ],
            forDate: "20260418",
            hash: "s1"
        )
        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(
                channelID: "BBC",
                start: ukDate(year: 2026, month: 4, day: 19, hour: 0, minute: 30),
                title: "next-day"
            )],
            forDate: "20260419",
            hash: "s2"
        )

        let result = try await dataSource.programmes(
            forChannelID: "BBC",
            onDate: ukDate(year: 2026, month: 4, day: 18, hour: 12)
        )

        #expect(Set(result.map(\.title)) == Set(["inside-start", "inside-midday"]))
    }

    @Test("programmes are returned in ascending start-time order")
    func programmesAreReturnedInAscendingStartTimeOrder() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let baseStart = ukDate(year: 2026, month: 4, day: 18, hour: 10)

        try await dataSource.replaceProgrammes(
            [
                TVProgramme.mock(channelID: "BBC", start: baseStart.addingTimeInterval(3600), title: "later"),
                TVProgramme.mock(channelID: "BBC", start: baseStart, title: "earlier")
            ],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: baseStart)

        #expect(result.map(\.title) == ["earlier", "later"])
    }

    // MARK: - nowPlayingProgrammes(at:)

    @Test("nowPlaying returns programmes currently airing")
    func nowPlayingReturnsProgrammesCurrentlyAiring() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let now = ukDate(year: 2026, month: 4, day: 18, hour: 12)

        try await dataSource.replaceProgrammes(
            [
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
            ],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.nowPlayingProgrammes(at: now)

        #expect(result.map(\.title) == ["on-now"])
    }

    @Test("nowPlaying excludes a programme whose endTime equals now")
    func nowPlayingExcludesProgrammesEndingAtNow() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let now = ukDate(year: 2026, month: 4, day: 18, hour: 12)

        // Ends exactly at `now`; the predicate is `endTime > now`, so it must be excluded.
        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(
                channelID: "BBC",
                start: now.addingTimeInterval(-1800),
                duration: 1800,
                title: "just-ended"
            )],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.nowPlayingProgrammes(at: now)

        #expect(result.isEmpty)
    }

    // MARK: - programmes(from:to:)

    @Test("programmes(from:to:) returns programmes overlapping the window")
    func programmesFromToReturnsOverlappingProgrammes() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let from = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let end = ukDate(year: 2026, month: 4, day: 18, hour: 14)

        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(
                channelID: "BBC",
                start: ukDate(year: 2026, month: 4, day: 18, hour: 12, minute: 30),
                duration: 1800,
                title: "in-window"
            )],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(from: from, to: end)

        #expect(result.map(\.title) == ["in-window"])
    }

    @Test("programmes(from:to:) are sorted by channelID then startTime")
    func programmesFromToSortedByChannelIDThenStartTime() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let from = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let end = ukDate(year: 2026, month: 4, day: 18, hour: 14)
        let base = ukDate(year: 2026, month: 4, day: 18, hour: 12, minute: 30)

        try await dataSource.replaceProgrammes(
            [
                TVProgramme.mock(channelID: "ITV", start: base, duration: 1800, title: "itv"),
                TVProgramme.mock(
                    channelID: "BBC",
                    start: base.addingTimeInterval(1800),
                    duration: 1800,
                    title: "bbc-later"
                ),
                TVProgramme.mock(channelID: "BBC", start: base, duration: 1800, title: "bbc-earlier")
            ],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(from: from, to: end)

        #expect(result.map(\.title) == ["bbc-earlier", "bbc-later", "itv"])
    }

    @Test("programmes(from:to:) excludes fully-past and fully-future programmes")
    func programmesFromToExcludesOutOfWindow() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let from = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let end = ukDate(year: 2026, month: 4, day: 18, hour: 14)

        try await dataSource.replaceProgrammes(
            [
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 10),
                    duration: 1800,
                    title: "fully-past"
                ),
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 12, minute: 30),
                    duration: 1800,
                    title: "in-window"
                ),
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 15),
                    duration: 1800,
                    title: "fully-future"
                )
            ],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(from: from, to: end)

        #expect(result.map(\.title) == ["in-window"])
    }

    @Test("programmes(from:to:) includes an in-progress programme started before the window")
    func programmesFromToIncludesInProgress() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let from = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let end = ukDate(year: 2026, month: 4, day: 18, hour: 14)

        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(
                channelID: "BBC",
                start: ukDate(year: 2026, month: 4, day: 18, hour: 11, minute: 30),
                duration: 3600,
                title: "in-progress"
            )],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(from: from, to: end)

        #expect(result.map(\.title) == ["in-progress"])
    }

    @Test("programmes(from:to:) excludes programmes touching the window boundaries")
    func programmesFromToExcludesTouchingBoundaries() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let from = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let end = ukDate(year: 2026, month: 4, day: 18, hour: 14)

        try await dataSource.replaceProgrammes(
            [
                // endTime == from -> excluded
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 11, minute: 30),
                    duration: 1800,
                    title: "ends-at-from"
                ),
                // startTime == to -> excluded
                TVProgramme.mock(
                    channelID: "BBC",
                    start: ukDate(year: 2026, month: 4, day: 18, hour: 14),
                    duration: 1800,
                    title: "starts-at-to"
                )
            ],
            forDate: "20260418",
            hash: "s1"
        )

        let result = try await dataSource.programmes(from: from, to: end)

        #expect(result.isEmpty)
    }

    @Test("programmes(from:to:) returns empty when nothing is in range")
    func programmesFromToReturnsEmptyWhenNothingInRange() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let from = ukDate(year: 2026, month: 4, day: 18, hour: 12)
        let end = ukDate(year: 2026, month: 4, day: 18, hour: 14)

        let result = try await dataSource.programmes(from: from, to: end)

        #expect(result.isEmpty)
    }

}
