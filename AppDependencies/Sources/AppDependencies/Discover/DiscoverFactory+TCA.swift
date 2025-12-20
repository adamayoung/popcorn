//
//  DiscoverFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DiscoverComposition
import Foundation
import PopcornDiscoverAdapters

extension DependencyValues {

    var discoverFactory: PopcornDiscoverFactory {
        PopcornDiscoverAdaptersFactory(
            discoverService: discoverService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchMovieGenresUseCase: fetchMovieGenres,
            fetchTVSeriesGenresUseCase: fetchTVSeriesGenres,
            fetchMovieImageCollectionUseCase: fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: fetchTVSeriesImageCollection
        ).makeDiscoverFactory()
    }

}
