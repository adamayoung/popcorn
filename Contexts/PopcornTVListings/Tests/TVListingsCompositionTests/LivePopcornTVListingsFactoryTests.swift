//
//  LivePopcornTVListingsFactoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsComposition
import TVListingsDomain
import TVListingsInfrastructure

@Suite("LivePopcornTVListingsFactory")
struct LivePopcornTVListingsFactoryTests {

    @Test("factory builds all use cases without crashing")
    func factoryBuildsAllUseCases() throws {
        let modelContainer = try TVListingsInfrastructureFactory.makeInMemoryModelContainer()

        let factory = LivePopcornTVListingsFactory(
            remoteDataSource: StubRemote(),
            modelContainer: modelContainer
        )

        _ = factory.makeSyncTVListingsUseCase()
        _ = factory.makeFetchTVChannelsUseCase()
        _ = factory.makeFetchTVChannelScheduleUseCase()
        _ = factory.makeFetchNowPlayingTVProgrammesUseCase()
    }

    private struct StubRemote: TVListingsRemoteDataSource {
        func fetchListings() async throws(TVListingsRemoteDataSourceError) -> TVListingsSnapshot {
            TVListingsSnapshot(channels: [], programmes: [])
        }
    }

}
