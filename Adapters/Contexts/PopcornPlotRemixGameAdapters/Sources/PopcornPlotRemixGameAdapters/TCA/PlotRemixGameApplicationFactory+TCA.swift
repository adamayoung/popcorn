//
//  PlotRemixGameApplicationFactory+TCA.swift
//  PopcornPlotRemixGameAdapters
//
//  Created by Adam Young on 11/12/2025.
//

import ComposableArchitecture
import Foundation
import PlotRemixGameApplication
import PopcornConfigurationAdapters
import PopcornDiscoverAdapters
import PopcornMoviesAdapters
import PopcornGenresAdapters
import TMDbAdapters

extension DependencyValues {

    var plotRemixGameApplicationFactory: PlotRemixGameApplicationFactory {
        PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: self.fetchDiscoverMovies,
            fetchSimilarMoviesUseCase: self.fetchSimilarMovies,
            fetchMovieGenresUseCase: self.fetchMovieGenres
        ).makePlotRemixGameFactory()
    }

}
