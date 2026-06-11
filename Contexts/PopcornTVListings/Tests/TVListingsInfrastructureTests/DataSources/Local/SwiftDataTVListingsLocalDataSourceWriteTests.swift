//
//  SwiftDataTVListingsLocalDataSourceWriteTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("SwiftDataTVListingsLocalDataSource writes")
struct SwiftDataTVListingsLocalDataSourceWriteTests {

    let modelContainer: ModelContainer

    init() throws {
        self.modelContainer = try TVListingsInfrastructureFactory.makeInMemoryModelContainer()
    }

    // MARK: - upsertChannels

    @Test("upsertChannels replaces the directory and leaves no orphan number rows")
    func upsertChannelsReplacesAndLeavesNoOrphans() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        try await dataSource.upsertChannels(
            [TVChannel.mock(id: "OLD", channelNumbers: [TVChannelNumber(channelNumber: "101", subbouquetIDs: [1])])],
            hash: "c1"
        )
        try await dataSource.upsertChannels(
            [TVChannel.mock(id: "NEW", channelNumbers: [TVChannelNumber(channelNumber: "202", subbouquetIDs: [3])])],
            hash: "c2"
        )

        let channels = try await dataSource.channels()
        #expect(channels.map(\.id) == ["NEW"])
        #expect(channels.first?.channelNumbers.map(\.channelNumber) == ["202"])
        #expect(numberEntityCount() == 1, "old channel's number rows must not orphan")
        let states = try await dataSource.fileStates()
        #expect(states["channels.json"] == "c2")
    }

    // MARK: - replaceProgrammes

    @Test("replaceProgrammes replaces only the day's own programmes")
    func replaceProgrammesReplacesOnlyThatDay() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let day1 = ukDate(year: 2026, month: 6, day: 11, hour: 12)
        let day2 = ukDate(year: 2026, month: 6, day: 12, hour: 12)

        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: day1, title: "d1")],
            forDate: "20260611",
            hash: "s1"
        )
        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: day2, title: "d2")],
            forDate: "20260612",
            hash: "s2"
        )

        // Rewriting day 2 must not touch day 1.
        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: day2, title: "d2-new")],
            forDate: "20260612",
            hash: "s2b"
        )

        let day1Result = try await dataSource.programmes(forChannelID: "BBC", onDate: day1)
        let day2Result = try await dataSource.programmes(forChannelID: "BBC", onDate: day2)
        #expect(day1Result.map(\.title) == ["d1"])
        #expect(day2Result.map(\.title) == ["d2-new"])
    }

    @Test("rewriting a day preserves the previous day's across-midnight spillover")
    func replaceProgrammesPreservesMidnightSpillover() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        // Starts 2026-06-11 23:30, runs 90 minutes into the 12th. Bucketed into the 11th's file.
        let lateNight = ukDate(year: 2026, month: 6, day: 11, hour: 23, minute: 30)
        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: lateNight, duration: 5400, title: "across-midnight")],
            forDate: "20260611",
            hash: "s1"
        )

        // Rewrite the 12th — must not delete the 11th's spillover programme.
        try await dataSource.replaceProgrammes([], forDate: "20260612", hash: "s2")

        let day12 = ukDate(year: 2026, month: 6, day: 12, hour: 0, minute: 30)
        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: day12)
        #expect(result.map(\.title) == ["across-midnight"])
    }

    @Test("same programmeID in two adjacent day files resolves to a single row")
    func sameProgrammeIDAcrossDaysIsSingleRow() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let start = ukDate(year: 2026, month: 6, day: 11, hour: 23, minute: 30)
        let programme = TVProgramme.mock(channelID: "BBC", start: start, duration: 5400, title: "shared")

        // Same programme listed in both the 11th and 12th schedule files.
        try await dataSource.replaceProgrammes([programme], forDate: "20260611", hash: "s1")
        try await dataSource.replaceProgrammes([programme], forDate: "20260612", hash: "s2")

        #expect(programmeEntityCount(id: programme.id) == 1)
    }

    // MARK: - deleteProgrammes(notInDates:)

    @Test("deleteProgrammes drops days outside the window and keeps retained days in full")
    func deleteProgrammesDropsPastDays() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let past = ukDate(year: 2026, month: 6, day: 10, hour: 12)
        let todayMorning = ukDate(year: 2026, month: 6, day: 11, hour: 7)
        let todayEvening = ukDate(year: 2026, month: 6, day: 11, hour: 21)

        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: past, title: "past")],
            forDate: "20260610",
            hash: "s0"
        )
        try await dataSource.replaceProgrammes(
            [
                TVProgramme.mock(channelID: "BBC", start: todayMorning, title: "morning"),
                TVProgramme.mock(channelID: "BBC", start: todayEvening, title: "evening")
            ],
            forDate: "20260611",
            hash: "s1"
        )

        try await dataSource.deleteProgrammes(notInDates: ["20260611"])

        let today = try await dataSource.programmes(forChannelID: "BBC", onDate: todayMorning)
        #expect(Set(today.map(\.title)) == Set(["morning", "evening"]), "already-aired today is kept")
        #expect(programmeEntityCount(id: TVProgramme.makeID(channelID: "BBC", startTime: past)) == 0)
    }

    @Test("deleteProgrammes with no dates is a no-op and never wipes the cache")
    func deleteProgrammesEmptyIsNoOp() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        let today = ukDate(year: 2026, month: 6, day: 11, hour: 12)
        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: today, title: "keep")],
            forDate: "20260611",
            hash: "s1"
        )

        try await dataSource.deleteProgrammes(notInDates: [])

        let result = try await dataSource.programmes(forChannelID: "BBC", onDate: today)
        #expect(result.map(\.title) == ["keep"])
    }

    // MARK: - Sync state

    @Test("completeSync stamps lastSyncedAt and prunes stale file-state rows")
    func completeSyncStampsAndPrunes() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)
        try await dataSource.upsertChannels([TVChannel.mock(id: "BBC")], hash: "c1")
        try await dataSource.replaceProgrammes([], forDate: "20260610", hash: "stale")

        let stamp = Date(timeIntervalSince1970: 2_000_000)
        try await dataSource.completeSync(lastSyncedAt: stamp, keepingFileStatePaths: ["channels.json"])

        let states = try await dataSource.fileStates()
        let lastSyncedAt = try await dataSource.lastSyncedAt()
        #expect(states.keys.sorted() == ["channels.json"], "stale schedule hash pruned")
        #expect(lastSyncedAt == stamp)
    }

    @Test("lastSyncedAt is nil before the first sync")
    func lastSyncedAtNilBeforeFirstSync() async throws {
        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.lastSyncedAt()

        #expect(result == nil)
    }

    // MARK: - Helpers

    private func numberEntityCount() -> Int {
        let context = ModelContext(modelContainer)
        return (try? context.fetchCount(FetchDescriptor<TVChannelNumberEntity>())) ?? -1
    }

    private func programmeEntityCount(id: String) -> Int {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<TVProgrammeEntity>(
            predicate: #Predicate { $0.programmeID == id }
        )
        return (try? context.fetchCount(descriptor)) ?? -1
    }

}
