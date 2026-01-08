//
//  TVSeriesApplicationFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

package final class TVSeriesApplicationFactory: Sendable {

    private let tvSeriesRepository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    package init(
        tvSeriesRepository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvSeriesRepository = tvSeriesRepository
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

}
