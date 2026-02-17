//
//  DiscoverFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DiscoverComposition
import Foundation
import PopcornDiscoverAdapters

enum PopcornDiscoverFactoryKey: DependencyKey {

    static var liveValue: PopcornDiscoverFactory {
        @Dependency(\.discoverService) var discoverService
        @Dependency(\.fetchMovieGenres) var fetchMovieGenres
        @Dependency(\.fetchTVSeriesGenres) var fetchTVSeriesGenres
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        @Dependency(\.fetchMovieImageCollection) var fetchMovieImageCollection
        @Dependency(\.fetchTVSeriesImageCollection) var fetchTVSeriesImageCollection

        return PopcornDiscoverAdaptersFactory(
            discoverService: discoverService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieGenresUseCase: fetchMovieGenres,
            fetchTVSeriesGenresUseCase: fetchTVSeriesGenres,
            fetchMovieImageCollectionUseCase: fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollection
        ).makeDiscoverFactory()
    }

}

extension DependencyValues {

    var discoverFactory: PopcornDiscoverFactory {
        get { self[PopcornDiscoverFactoryKey.self] }
        set { self[PopcornDiscoverFactoryKey.self] = newValue }
    }

}
