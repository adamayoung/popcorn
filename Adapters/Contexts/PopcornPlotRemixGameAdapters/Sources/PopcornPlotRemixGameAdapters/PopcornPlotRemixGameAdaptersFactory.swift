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

///
/// A factory for creating plot remix game-related adapters.
///
/// Creates adapters that bridge various application use cases to the
/// plot remix game domain.
///
public final class PopcornPlotRemixGameAdaptersFactory {

    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase
    private let fetchMovieRecommendationsUseCase: any FetchMovieRecommendationsUseCase
    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase
    private let observability: any Observing

    ///
    /// Creates a plot remix game adapters factory.
    ///
    /// - Parameters:
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///   - fetchDiscoverMoviesUseCase: The use case for discovering movies.
    ///   - fetchMovieRecommendationsUseCase: The use case for fetching movie recommendations.
    ///   - fetchMovieGenresUseCase: The use case for fetching movie genres.
    ///   - observability: The observability service.
    ///
    public init(
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchDiscoverMoviesUseCase: some FetchDiscoverMoviesUseCase,
        fetchMovieRecommendationsUseCase: some FetchMovieRecommendationsUseCase,
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase,
        observability: any Observing
    ) {
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchDiscoverMoviesUseCase = fetchDiscoverMoviesUseCase
        self.fetchMovieRecommendationsUseCase = fetchMovieRecommendationsUseCase
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
        self.observability = observability
    }

    ///
    /// Creates a plot remix game factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornPlotRemixGameFactory`` instance.
    ///
    public func makePlotRemixGameFactory() -> PopcornPlotRemixGameFactory {
        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )
        let movieProvider = MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: fetchDiscoverMoviesUseCase,
            fetchMovieRecommendationsUseCase: fetchMovieRecommendationsUseCase
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
