//
//  PlotRemixGameApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PlotRemixGameComposition
import PopcornPlotRemixGameAdapters

enum PopcornPlotRemixGameFactoryKey: DependencyKey {

    static var liveValue: PopcornPlotRemixGameFactory {
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        @Dependency(\.fetchDiscoverMovies) var fetchDiscoverMovies
        @Dependency(\.fetchMovieRecommendations) var fetchMovieRecommendations
        @Dependency(\.fetchMovieGenres) var fetchMovieGenres
        @Dependency(\.observability) var observability
        return PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: fetchDiscoverMovies,
            fetchMovieRecommendationsUseCase: fetchMovieRecommendations,
            fetchMovieGenresUseCase: fetchMovieGenres,
            observability: observability
        ).makePlotRemixGameFactory()
    }

}

extension DependencyValues {

    var plotRemixGameFactory: PopcornPlotRemixGameFactory {
        get { self[PopcornPlotRemixGameFactoryKey.self] }
        set { self[PopcornPlotRemixGameFactoryKey.self] = newValue }
    }

}
