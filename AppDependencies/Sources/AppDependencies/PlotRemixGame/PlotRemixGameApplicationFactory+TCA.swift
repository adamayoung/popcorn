//
//  PlotRemixGameApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PlotRemixGameComposition
import PopcornPeopleAdapters
import PopcornPlotRemixGameAdapters

extension DependencyValues {

    var plotRemixGameFactory: PopcornPlotRemixGameFactory {
        PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: fetchDiscoverMovies,
            fetchMovieRecommendationsUseCase: fetchMovieRecommendations,
            fetchMovieGenresUseCase: fetchMovieGenres,
            observability: observability
        ).makePlotRemixGameFactory()
    }

}
