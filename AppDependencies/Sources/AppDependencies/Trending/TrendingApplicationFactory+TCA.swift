//
//  TrendingApplicationFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornTrendingAdapters
import TrendingComposition

extension DependencyValues {

    var trendingFactory: PopcornTrendingFactory {
        PopcornTrendingAdaptersFactory(
            trendingService: trendingService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollection
        ).makeTrendingFactory()
    }

}
