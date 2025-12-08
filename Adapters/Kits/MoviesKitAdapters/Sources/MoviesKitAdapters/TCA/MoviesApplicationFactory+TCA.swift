//
//  MoviesApplicationFactory+TCA.swift
//  MoviesKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationKitAdapters
import Foundation
import MoviesApplication
import TMDbAdapters

extension DependencyValues {

    var moviesFactory: MoviesApplicationFactory {
        MoviesKitAdaptersFactory(
            movieService: self.movieService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeMoviesFactory()
    }

}
