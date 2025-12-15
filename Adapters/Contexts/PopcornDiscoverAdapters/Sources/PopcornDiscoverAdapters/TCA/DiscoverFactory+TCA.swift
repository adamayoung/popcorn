//
//  DiscoverFactory+TCA.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import DiscoverComposition
import Foundation
import PopcornConfigurationAdapters
import PopcornGenresAdapters
import PopcornMoviesAdapters
import PopcornTVAdapters
import TMDbAdapters

extension DependencyValues {

    var discoverFactory: PopcornDiscoverFactory {
        PopcornDiscoverAdaptersFactory(
            discoverService: self.discoverService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchMovieGenresUseCase: self.fetchMovieGenres,
            fetchTVSeriesGenresUseCase: self.fetchTVSeriesGenres,
            fetchMovieImageCollectionUseCase: self.fetchMovieImageCollection,
            fetchTVSeriesImageCollectionUseCase: self.fetchTVSeriesImageCollection
        ).makeDiscoverFactory()
    }

}
