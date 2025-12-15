//
//  PopcornPlotRemixGameAdaptersFactory.swift
//  PopcornPlotRemixGameAdapters
//
//  Created by Adam Young on 11/12/2025.
//

import ConfigurationApplication
import DiscoverApplication
import Foundation
import GenresApplication
import MoviesApplication
import PlotRemixGameApplication
import TMDb

struct PopcornPlotRemixGameAdaptersFactory {

    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase
    let fetchSimilarMoviesUseCase: any FetchSimilarMoviesUseCase
    let fetchMovieGenresUseCase: any FetchMovieGenresUseCase

    func makePlotRemixGameFactory() -> PlotRemixGameApplicationFactory {
        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )
        let movieProvider = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: fetchDiscoverMoviesUseCase,
            fetchSimilarMoviesUseCase: fetchSimilarMoviesUseCase
        )
        let genreProvider = GenreProviderAdapter(fetchMovieGenresUseCase: fetchMovieGenresUseCase)

        return PlotRemixGameComposition.makeGameFactory(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
        )
    }

}
