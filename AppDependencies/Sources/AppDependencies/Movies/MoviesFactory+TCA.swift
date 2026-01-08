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

enum PopcornMoviesFactoryKey: DependencyKey {

    static var liveValue: PopcornMoviesFactory {
        @Dependency(\.movieService) var movieService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        return PopcornMoviesAdaptersFactory(
            movieService: movieService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makeMoviesFactory()
    }

}

extension DependencyValues {

    var moviesFactory: PopcornMoviesFactory {
        get { self[PopcornMoviesFactoryKey.self] }
        set { self[PopcornMoviesFactoryKey.self] = newValue }
    }

}
