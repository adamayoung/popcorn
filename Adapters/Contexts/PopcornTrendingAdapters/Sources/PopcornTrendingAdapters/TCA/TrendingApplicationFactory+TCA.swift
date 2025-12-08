//
//  TrendingApplicationFactory+TCA.swift
//  PopcornTrendingAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornConfigurationAdapters
import PopcornMoviesAdapters
import PopcornTVAdapters
import TMDbAdapters
import TrendingApplication

extension DependencyValues {

    var trendingFactory: TrendingApplicationFactory {
        PopcornTrendingAdaptersFactory(
            trendingService: self.trendingService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: self.fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: self.fetchTVSeriesImageCollection,
        ).makeTrendingFactory()
    }

}
