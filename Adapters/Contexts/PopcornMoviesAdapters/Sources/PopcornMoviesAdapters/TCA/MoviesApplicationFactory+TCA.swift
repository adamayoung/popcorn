//
//  MoviesApplicationFactory+TCA.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication
import PopcornConfigurationAdapters
import TMDbAdapters

extension DependencyValues {

    var moviesFactory: MoviesApplicationFactory {
        PopcornMoviesAdaptersFactory(
            movieService: self.movieService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeMoviesFactory()
    }

}
