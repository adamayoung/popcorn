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
    private let tvProgrammeRepository: any TVProgrammeRepository
    private let tvListingsSyncRepository: any TVListingsSyncRepository

    package init(
        channelRepository: some ChannelRepository,
        tvProgrammeRepository: some TVProgrammeRepository,
        tvListingsSyncRepository: some TVListingsSyncRepository
    ) {
        self.channelRepository = channelRepository
        self.tvProgrammeRepository = tvProgrammeRepository
        self.tvListingsSyncRepository = tvListingsSyncRepository
    }

    package func makeSyncTVListingsIfNeededUseCase() -> some SyncTVListingsIfNeededUseCase {
        DefaultSyncTVListingsIfNeededUseCase(tvListingsSyncRepository: tvListingsSyncRepository)
    }

    package func makeFetchChannelsUseCase() -> some FetchChannelsUseCase {
        DefaultFetchChannelsUseCase(channelRepository: channelRepository)
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
