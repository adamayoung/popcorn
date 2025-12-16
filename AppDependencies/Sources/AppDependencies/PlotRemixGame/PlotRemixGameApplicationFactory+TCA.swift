//
//  PlotRemixGameApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 11/12/2025.
//

import ComposableArchitecture
import Foundation
import PlotRemixGameComposition
import PopcornPeopleAdapters
import PopcornPlotRemixGameAdapters

extension DependencyValues {

    var plotRemixGameFactory: PopcornPlotRemixGameFactory {
        PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: self.fetchDiscoverMovies,
            fetchSimilarMoviesUseCase: self.fetchSimilarMovies,
            fetchMovieGenresUseCase: self.fetchMovieGenres
        ).makePlotRemixGameFactory()
    }

}
