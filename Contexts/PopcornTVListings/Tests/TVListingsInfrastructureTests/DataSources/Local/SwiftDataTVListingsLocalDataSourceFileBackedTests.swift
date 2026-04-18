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

    @Test("replaceAll wipes previously inserted channel numbers without tripping SQLite batch-delete triggers")
    func replaceAllWipesPreviouslyInsertedChannelNumbersOnDisk() async throws {
        let (container, storeURL) = try makeFileBackedContainer()
        defer { ModelContainerFactory.removeSQLiteFiles(at: storeURL) }

        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: container)

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

    @Test("replaceAll wipes channel numbers even when the replacement carries no numbers")
    func replaceAllWipesChannelNumbersWhenReplacementCarriesNone() async throws {
        let (container, storeURL) = try makeFileBackedContainer()
        defer { ModelContainerFactory.removeSQLiteFiles(at: storeURL) }

        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: container)

        try await dataSource.replaceAll(
            channels: [
                TVChannel.mock(
                    id: "BBC",
                    name: "BBC",
                    channelNumbers: [
                        TVChannelNumber(channelNumber: "101", subbouquetIDs: [1])
                    ]
                )
            ],
            programmes: []
        )

        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "BBC", name: "BBC", channelNumbers: [])],
            programmes: []
        )

        let channels = try await dataSource.channels()
        #expect(channels.count == 1)
        #expect(channels.first?.channelNumbers.isEmpty == true)
    }

    @Test("replaceAll persists programmes across a full wipe-and-replace on disk")
    func replaceAllPersistsProgrammesOnDisk() async throws {
        let (container, storeURL) = try makeFileBackedContainer()
        defer { ModelContainerFactory.removeSQLiteFiles(at: storeURL) }

        let dataSource = SwiftDataTVListingsLocalDataSource(modelContainer: container)
        let now = Date(timeIntervalSince1970: 1_776_463_200)

        try await dataSource.replaceAll(
            channels: [TVChannel.mock(id: "BBC", name: "BBC", channelNumbers: [])],
            programmes: [
                TVProgramme.mock(
                    channelID: "BBC",
                    start: now.addingTimeInterval(-60),
                    duration: 600,
                    title: "on-now"
                )
            ]
        )

        let result = try await dataSource.nowPlayingProgrammes(at: now)
        #expect(result.map(\.title) == ["on-now"])
    }

    // MARK: - Helpers

    private func makeFileBackedContainer() throws -> (ModelContainer, URL) {
        let schema = Schema([
            TVChannelEntity.self,
            TVChannelNumberEntity.self,
            TVProgrammeEntity.self
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
