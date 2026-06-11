//
//  SwiftDataTVListingsLocalDataSourceRangeTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("SwiftDataTVListingsLocalDataSource range reads")
struct SwiftDataTVListingsLocalDataSourceRangeTests {

    let modelContainer: ModelContainer

    init() throws {
        self.modelContainer = try TVListingsInfrastructureFactory.makeInMemoryModelContainer()
    }

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
