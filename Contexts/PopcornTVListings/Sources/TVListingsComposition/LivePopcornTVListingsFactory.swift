//
//  LivePopcornTVListingsFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import TVListingsApplication
import TVListingsInfrastructure

public final class LivePopcornTVListingsFactory: PopcornTVListingsFactory {

    /// The shared on-disk container used when no container is injected. Materialised lazily
    /// so tests that inject their own container never touch the production store.
    private static let defaultModelContainer: ModelContainer =
        TVListingsInfrastructureFactory.makeDefaultModelContainer()

    ///
    /// Builds an in-memory `ModelContainer` suitable for tests. Pass the result into
    /// `init(remoteDataSource:modelContainer:)` to avoid touching the production store.
    ///
    public static func makeInMemoryModelContainer() throws -> ModelContainer {
        try TVListingsInfrastructureFactory.makeInMemoryModelContainer()
    }

    private let applicationFactory: TVListingsApplicationFactory

    public convenience init(remoteDataSource: some TVListingsRemoteDataSource) {
        self.init(
            remoteDataSource: remoteDataSource,
            modelContainer: Self.defaultModelContainer
        )
    }

    public init(
        remoteDataSource: some TVListingsRemoteDataSource,
        modelContainer: ModelContainer
    ) {
        let infrastructureFactory = TVListingsInfrastructureFactory(
            remoteDataSource: remoteDataSource,
            modelContainer: modelContainer
        )
        self.applicationFactory = TVListingsApplicationFactory(
            tvChannelRepository: infrastructureFactory.makeTVChannelRepository(),
            tvProgrammeRepository: infrastructureFactory.makeTVProgrammeRepository(),
            tvListingsSyncRepository: infrastructureFactory.makeTVListingsSyncRepository()
        )
    }

    public func makeSyncTVListingsUseCase() -> SyncTVListingsUseCase {
        applicationFactory.makeSyncTVListingsUseCase()
    }

    public func makeFetchTVChannelsUseCase() -> FetchTVChannelsUseCase {
        applicationFactory.makeFetchTVChannelsUseCase()
    }

    public func makeFetchTVChannelScheduleUseCase() -> FetchTVChannelScheduleUseCase {
        applicationFactory.makeFetchTVChannelScheduleUseCase()
    }

    public func makeFetchNowPlayingTVProgrammesUseCase() -> FetchNowPlayingTVProgrammesUseCase {
        applicationFactory.makeFetchNowPlayingTVProgrammesUseCase()
    }

}
