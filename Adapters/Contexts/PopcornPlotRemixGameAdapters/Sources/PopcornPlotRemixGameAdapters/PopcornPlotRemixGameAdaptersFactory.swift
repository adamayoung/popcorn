//
//  PopcornPlotRemixGameAdaptersFactory.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import DiscoverApplication
import Foundation
import GenresApplication
import MoviesApplication
import Observability
import PlotRemixGameComposition
import TMDb

public final class PopcornPlotRemixGameAdaptersFactory {

    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase
    private let fetchSimilarMoviesUseCase: any FetchSimilarMoviesUseCase
    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let observability: any Observing

    public init(
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchDiscoverMoviesUseCase: some FetchDiscoverMoviesUseCase,
        fetchSimilarMoviesUseCase: some FetchSimilarMoviesUseCase,
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase,
        observability: any Observing
    ) {
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchDiscoverMoviesUseCase = fetchDiscoverMoviesUseCase
        self.fetchSimilarMoviesUseCase = fetchSimilarMoviesUseCase
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
        self.observability = observability
    }

    public func makePlotRemixGameFactory() -> PopcornPlotRemixGameFactory {
        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )
        let movieProvider = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: fetchDiscoverMoviesUseCase,
            fetchSimilarMoviesUseCase: fetchSimilarMoviesUseCase
        )
        let genreProvider = GenreProviderAdapter(fetchMovieGenresUseCase: fetchMovieGenresUseCase)

        return PopcornPlotRemixGameFactory(
            appConfigurationProvider: appConfigurationProvider,
            movieProvider: movieProvider,
            genreProvider: genreProvider,
            observability: observability
        )
    }

}
