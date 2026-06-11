//
//  PopcornTVListingsAdaptersFactoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsComposition

@Suite("PopcornTVListingsAdaptersFactory")
struct PopcornTVListingsAdaptersFactoryTests {

    @Test("factory builds a remote data source that drives the tv listings factory")
    func factoryBuildsTVListingsFactory() throws {
        let modelContainer = try PopcornTVListingsFactory.makeInMemoryModelContainer()
        let adapters = PopcornTVListingsAdaptersFactory()

        let tvListingsFactory = PopcornTVListingsFactory(
            remoteDataSource: adapters.makeRemoteDataSource(),
            modelContainer: modelContainer
        )

        _ = tvListingsFactory.makeSyncTVListingsIfNeededUseCase()
        _ = tvListingsFactory.makeFetchTVChannelsUseCase()
        _ = tvListingsFactory.makeFetchTVChannelScheduleUseCase()
        _ = tvListingsFactory.makeFetchNowPlayingTVProgrammesUseCase()
    }

}
