//
//  TrendingApplicationFactory+TCA.swift
//  TrendingKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationKitAdapters
import Foundation
import MoviesKitAdapters
import TMDbAdapters
import TVKitAdapters
import TrendingApplication

extension DependencyValues {

    var trendingFactory: TrendingApplicationFactory {
        TrendingKitAdaptersFactory(
            trendingService: self.trendingService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: self.fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: self.fetchTVSeriesImageCollection,
        ).makeTrendingFactory()
    }

}
