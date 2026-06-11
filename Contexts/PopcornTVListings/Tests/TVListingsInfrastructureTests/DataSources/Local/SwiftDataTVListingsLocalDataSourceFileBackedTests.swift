//
//  SwiftDataTVListingsLocalDataSourceFileBackedTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import SwiftData
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

///
/// Regression tests that exercise the local data source against a real on-disk
/// SQLite store. These guard against persistence-layer issues — especially Core
/// Data batch-delete constraint triggers — that the default in-memory
/// `ModelContainer` doesn't enforce.
///
@Suite("SwiftDataTVListingsLocalDataSource (file-backed)")
struct SwiftDataTVListingsLocalDataSourceFileBackedTests {

    @Test("upsertChannels wipes previous channel numbers without tripping SQLite batch-delete triggers")
    func upsertChannelsWipesPreviousNumbersOnDisk() async throws {
        let (container, storeURL) = try makeFileBackedContainer()
        defer { ModelContainerFactory.removeSQLiteFiles(at: storeURL) }

        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: container)

        try await dataSource.upsertChannels(
            [TVChannel.mock(
                id: "OLD",
                name: "Old",
                channelNumbers: [TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 2])]
            )],
            hash: "c1"
        )
        try await dataSource.upsertChannels(
            [TVChannel.mock(
                id: "NEW",
                name: "New",
                channelNumbers: [TVChannelNumber(channelNumber: "202", subbouquetIDs: [3])]
            )],
            hash: "c2"
        )

        let channels = try await dataSource.channels()
        #expect(channels.count == 1)
        #expect(channels.first?.id == "NEW")
        #expect(channels.first?.channelNumbers.map(\.channelNumber) == ["202"])
    }

    @Test("replaceProgrammes persists a day's programmes across a real store")
    func replaceProgrammesPersistsOnDisk() async throws {
        let (container, storeURL) = try makeFileBackedContainer()
        defer { ModelContainerFactory.removeSQLiteFiles(at: storeURL) }

        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: container)
        let now = ukDate(year: 2026, month: 6, day: 11, hour: 12)

        try await dataSource.replaceProgrammes(
            [TVProgramme.mock(channelID: "BBC", start: now.addingTimeInterval(-60), duration: 600, title: "on-now")],
            forDate: "20260611",
            hash: "s1"
        )

        let result = try await dataSource.nowPlayingProgrammes(at: now)
        #expect(result.map(\.title) == ["on-now"])
    }

    // MARK: - Helpers

    private func makeFileBackedContainer() throws -> (ModelContainer, URL) {
        let schema = Schema([
            TVChannelEntity.self,
            TVChannelNumberEntity.self,
            TVProgrammeEntity.self,
            EPGFileStateEntity.self,
            EPGSyncStateEntity.self
        ])
        let storeURL = FileManager.default
            .temporaryDirectory
            .appending(path: "popcorn-tvlistings-test-\(UUID().uuidString).sqlite")

        let configuration = ModelConfiguration(
            schema: schema,
            url: storeURL,
            cloudKitDatabase: .none
        )
        let container = try ModelContainer(for: schema, configurations: [configuration])
        return (container, storeURL)
    }

}
