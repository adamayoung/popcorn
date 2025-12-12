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
import PopcornGenresAdapters
import TMDbAdapters

extension DependencyValues {

    var plotRemixGameApplicationFactory: PlotRemixGameApplicationFactory {
        PopcornPlotRemixGameAdaptersFactory(
            fetchAppConfigurationUseCase: self.fetchAppConfiguration,
            fetchDiscoverMoviesUseCase: self.fetchDiscoverMovies,
            fetchMovieGenresUseCase: self.fetchMovieGenres
        ).makePlotRemixGameFactory()
    }

}
