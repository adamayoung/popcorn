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

    @Test("factory builds tv listings factory without crashing")
    func factoryBuildsTVListingsFactory() throws {
        let modelContainer = try LivePopcornTVListingsFactory.makeInMemoryModelContainer()
        let factory = PopcornTVListingsAdaptersFactory(modelContainer: modelContainer)

        let tvListingsFactory = factory.makeTVListingsFactory()

        _ = tvListingsFactory.makeSyncTVListingsUseCase()
        _ = tvListingsFactory.makeFetchTVChannelsUseCase()
        _ = tvListingsFactory.makeFetchTVChannelScheduleUseCase()
        _ = tvListingsFactory.makeFetchNowPlayingTVProgrammesUseCase()
    }

}
