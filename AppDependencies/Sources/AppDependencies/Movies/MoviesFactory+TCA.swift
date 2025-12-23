//
//  MoviesFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesComposition
import PopcornMoviesAdapters

extension DependencyValues {

    var moviesFactory: PopcornMoviesFactory {
        PopcornMoviesAdaptersFactory(
            movieService: movieService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makeMoviesFactory()
    }

}
