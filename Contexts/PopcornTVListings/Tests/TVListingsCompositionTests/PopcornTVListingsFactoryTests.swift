//
//  PopcornTVListingsFactoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsComposition
import TVListingsDomain
import TVListingsInfrastructure

@Suite("PopcornTVListingsFactory")
struct PopcornTVListingsFactoryTests {

    @Test("factory builds all use cases without crashing")
    func factoryBuildsAllUseCases() throws {
        let modelContainer = try TVListingsInfrastructureFactory.makeInMemoryModelContainer()

        let factory = PopcornTVListingsFactory(
            remoteDataSource: StubRemote(),
            modelContainer: modelContainer
        )

        _ = factory.makeSyncTVListingsIfNeededUseCase()
        _ = factory.makeFetchTVChannelsUseCase()
        _ = factory.makeFetchTVChannelScheduleUseCase()
        _ = factory.makeFetchNowPlayingTVProgrammesUseCase()
    }

    private struct StubRemote: TVListingsRemoteDataSource {
        func fetchManifest() async throws(TVListingsRemoteDataSourceError) -> EPGManifest {
            EPGManifest(generatedAt: Date(timeIntervalSince1970: 0), dates: [], files: [])
        }

        func fetchChannels() async throws(TVListingsRemoteDataSourceError) -> [TVChannel] {
            []
        }

        func fetchSchedule(
            forDate date: String
        ) async throws(TVListingsRemoteDataSourceError) -> [TVProgramme] {
            []
        }
    }

}
