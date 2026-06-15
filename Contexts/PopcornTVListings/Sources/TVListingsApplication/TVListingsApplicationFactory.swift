//
//  TVListingsApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

package final class TVListingsApplicationFactory: Sendable {

    private let channelRepository: any ChannelRepository
    private let tvRegionRepository: any TVRegionRepository
    private let tvProgrammeRepository: any TVProgrammeRepository
    private let tvListingsSyncRepository: any TVListingsSyncRepository

    package init(
        channelRepository: some ChannelRepository,
        tvRegionRepository: some TVRegionRepository,
        tvProgrammeRepository: some TVProgrammeRepository,
        tvListingsSyncRepository: some TVListingsSyncRepository
    ) {
        self.channelRepository = channelRepository
        self.tvRegionRepository = tvRegionRepository
        self.tvProgrammeRepository = tvProgrammeRepository
        self.tvListingsSyncRepository = tvListingsSyncRepository
    }

    package func makeSyncTVListingsIfNeededUseCase() -> some SyncTVListingsIfNeededUseCase {
        DefaultSyncTVListingsIfNeededUseCase(tvListingsSyncRepository: tvListingsSyncRepository)
    }

    package func makeFetchChannelsUseCase() -> some FetchChannelsUseCase {
        DefaultFetchChannelsUseCase(channelRepository: channelRepository)
    }

    package func makeFetchTVRegionsUseCase() -> some FetchTVRegionsUseCase {
        DefaultFetchTVRegionsUseCase(tvRegionRepository: tvRegionRepository)
    }

    package func makeFetchChannelScheduleUseCase() -> some FetchChannelScheduleUseCase {
        DefaultFetchChannelScheduleUseCase(tvProgrammeRepository: tvProgrammeRepository)
    }

    package func makeFetchNowPlayingTVProgrammesUseCase() -> some FetchNowPlayingTVProgrammesUseCase {
        DefaultFetchNowPlayingTVProgrammesUseCase(tvProgrammeRepository: tvProgrammeRepository)
    }

    package func makeFetchTVListingsUseCase() -> some FetchTVListingsUseCase {
        DefaultFetchTVListingsUseCase(tvProgrammeRepository: tvProgrammeRepository)
    }

}
