//
//  TrendingApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornTrendingAdapters
import TrendingComposition

enum PopcornTrendingFactoryKey: DependencyKey {

    static var liveValue: PopcornTrendingFactory {
        @Dependency(\.trendingService) var trendingService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        @Dependency(\.fetchMovieImageCollection) var fetchMovieImageCollection
        @Dependency(\.fetchTVSeriesImageCollection) var fetchTVSeriesImageCollection
        @Dependency(\.themeColorProvider) var themeColorProvider
        return PopcornTrendingAdaptersFactory(
            trendingService: trendingService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieImageCollectionUseCase: fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollection,
            themeColorProvider: themeColorProvider
        ).makeTrendingFactory()
    }

}

extension DependencyValues {

    var trendingFactory: PopcornTrendingFactory {
        get { self[PopcornTrendingFactoryKey.self] }
        set { self[PopcornTrendingFactoryKey.self] = newValue }
    }

}
