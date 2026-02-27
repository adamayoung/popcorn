//
//  TVSeriesApplicationFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

package final class TVSeriesApplicationFactory: Sendable {

    private let tvSeriesRepository: any TVSeriesRepository
    private let tvSeasonRepository: any TVSeasonRepository
    private let tvEpisodeRepository: any TVEpisodeRepository
    private let tvSeriesCreditsRepository: any TVSeriesCreditsRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    package init(
        tvSeriesRepository: some TVSeriesRepository,
        tvSeasonRepository: some TVSeasonRepository,
        tvEpisodeRepository: some TVEpisodeRepository,
        tvSeriesCreditsRepository: some TVSeriesCreditsRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvSeriesRepository = tvSeriesRepository
        self.tvSeasonRepository = tvSeasonRepository
        self.tvEpisodeRepository = tvEpisodeRepository
        self.tvSeriesCreditsRepository = tvSeriesCreditsRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    package func makeFetchTVSeriesDetailsUseCase() -> some FetchTVSeriesDetailsUseCase {
        DefaultFetchTVSeriesDetailsUseCase(
            repository: tvSeriesRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchTVSeriesImageCollectionUseCase()
    -> some FetchTVSeriesImageCollectionUseCase {
        DefaultFetchTVSeriesImageCollectionUseCase(
            repository: tvSeriesRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchTVSeasonDetailsUseCase() -> some FetchTVSeasonDetailsUseCase {
        DefaultFetchTVSeasonDetailsUseCase(
            repository: tvSeasonRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchTVEpisodeDetailsUseCase() -> some FetchTVEpisodeDetailsUseCase {
        DefaultFetchTVEpisodeDetailsUseCase(
            repository: tvEpisodeRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchTVSeriesCreditsUseCase() -> some FetchTVSeriesCreditsUseCase {
        DefaultFetchTVSeriesCreditsUseCase(
            tvSeriesCreditsRepository: tvSeriesCreditsRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchTVSeriesAggregateCreditsUseCase()
    -> some FetchTVSeriesAggregateCreditsUseCase {
        DefaultFetchTVSeriesAggregateCreditsUseCase(
            tvSeriesCreditsRepository: tvSeriesCreditsRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
