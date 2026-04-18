//
//  TVListingsApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

package final class TVListingsApplicationFactory: Sendable {

    private let tvChannelRepository: any TVChannelRepository
    private let tvProgrammeRepository: any TVProgrammeRepository
    private let tvListingsSyncRepository: any TVListingsSyncRepository

    package init(
        tvChannelRepository: some TVChannelRepository,
        tvProgrammeRepository: some TVProgrammeRepository,
        tvListingsSyncRepository: some TVListingsSyncRepository
    ) {
        self.tvChannelRepository = tvChannelRepository
        self.tvProgrammeRepository = tvProgrammeRepository
        self.tvListingsSyncRepository = tvListingsSyncRepository
    }

    package func makeSyncTVListingsUseCase() -> some SyncTVListingsUseCase {
        DefaultSyncTVListingsUseCase(tvListingsSyncRepository: tvListingsSyncRepository)
    }

    package func makeFetchTVChannelsUseCase() -> some FetchTVChannelsUseCase {
        DefaultFetchTVChannelsUseCase(tvChannelRepository: tvChannelRepository)
    }

    package func makeFetchTVChannelScheduleUseCase() -> some FetchTVChannelScheduleUseCase {
        DefaultFetchTVChannelScheduleUseCase(tvProgrammeRepository: tvProgrammeRepository)
    }

    package func makeFetchNowPlayingTVProgrammesUseCase() -> some FetchNowPlayingTVProgrammesUseCase {
        DefaultFetchNowPlayingTVProgrammesUseCase(tvProgrammeRepository: tvProgrammeRepository)
    }

}
