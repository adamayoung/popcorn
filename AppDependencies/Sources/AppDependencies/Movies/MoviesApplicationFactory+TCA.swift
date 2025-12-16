//
//  MoviesApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import MoviesComposition
import PopcornMoviesAdapters

extension DependencyValues {

    var moviesFactory: PopcornMoviesFactory {
        PopcornMoviesAdaptersFactory(
            movieService: self.movieService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeMoviesFactory()
    }

}
