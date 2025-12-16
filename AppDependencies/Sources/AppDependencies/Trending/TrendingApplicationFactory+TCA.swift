//
//  TrendingApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornTrendingAdapters
import TrendingComposition

extension DependencyValues {

    var trendingFactory: PopcornTrendingFactory {
        PopcornTrendingAdaptersFactory(
            trendingService: self.trendingService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: self.fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: self.fetchTVSeriesImageCollection,
        ).makeTrendingFactory()
    }

}
