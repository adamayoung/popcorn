//
//  DefaultTVListingsSyncRepositoryFileBackedTests.swift
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
/// Exercises a full sync against a **real on-disk** store using the production schema, then
/// reads it back the way the feature does (channels, regions, and the `programmes(from:to:)`
/// range query that drives the now-playing list). Guards against an on-disk write/read failure
/// that the in-memory suites miss — exactly the kind of silent failure that leaves the screen
/// showing "nothing on right now".
///
@Suite("DefaultTVListingsSyncRepository (file-backed)")
struct DefaultTVListingsSyncRepositoryFileBackedTests {

    @Test("a full sync populates channels, regions, and now-playing programmes on a real store")
    func fullSyncPopulatesOnDiskStore() async throws {
        let (container, storeURL) = try makeFileBackedContainer()
        defer { ModelContainerFactory.removeSQLiteFiles(at: storeURL) }
        let local = SwiftDataTVListingsLocalDataSource(modelContainer: container)

        let now = ukDate(year: 2026, month: 6, day: 16, hour: 12)
        let remote = MockTVListingsRemoteDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260616"], channelsHash: "c1", regionsHash: "r1", scheduleHashes: ["20260616": "s1"])
        )
        remote.fetchChannelsStub = .success([
            Channel.mock(
                id: "BBC_ONE",
                name: "BBC One",
                channelNumbers: [ChannelNumber(
                    channelNumber: "101",
                    regions: [ChannelRegion(bouquet: 4101, subBouquet: 1)]
                )]
            )
        ])
        remote.fetchRegionsStub = .success([
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        ])
        remote.fetchScheduleStubs["20260616"] = .success([
            TVProgramme.mock(channelID: "BBC_ONE", start: now.addingTimeInterval(-600), duration: 3600, title: "News")
        ])

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: remote,
            localDataSource: local,
            now: { now }
        )

        try await repository.sync()

        let channels = try await local.channels()
        let regions = try await local.regions()
        let listings = try await local.programmes(from: now, to: now.addingTimeInterval(24 * 60 * 60))

        #expect(channels.map(\.id) == ["BBC_ONE"])
        #expect(regions.map(\.id) == ["4101-1"])
        #expect(listings.map(\.title) == ["News"], "the now-playing range query must return the synced programme")
    }

    private func makeFileBackedContainer() throws -> (ModelContainer, URL) {
        // Mirror the production schema exactly (TVListingsInfrastructureFactory.schema).
        let schema = Schema([
            ChannelEntity.self,
            ChannelNumberEntity.self,
            TVRegionEntity.self,
            TVProgrammeEntity.self,
            EPGFileStateEntity.self,
            EPGSyncStateEntity.self
        ])
        let storeURL = FileManager.default
            .temporaryDirectory
            .appending(path: "popcorn-tvlistings-sync-test-\(UUID().uuidString).sqlite")
        let configuration = ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        return (container, storeURL)
    }

}
