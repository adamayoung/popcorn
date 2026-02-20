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
    private let appConfigurationProvider: any AppConfigurationProviding

    package init(
        tvSeriesRepository: some TVSeriesRepository,
        tvSeasonRepository: some TVSeasonRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvSeriesRepository = tvSeriesRepository
        self.tvSeasonRepository = tvSeasonRepository
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

}
