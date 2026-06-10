//
//  PopcornPlotRemixGameAdaptersFactory.swift
//  PopcornPlotRemixGameAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import DiscoverApplication
import GenresApplication
import MoviesApplication
import PlotRemixGameDomain

public final class PopcornPlotRemixGameAdaptersFactory {

    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase
    private let fetchDiscoverMoviesUseCase: any FetchDiscoverMoviesUseCase
    private let fetchMovieRecommendationsUseCase: any FetchMovieRecommendationsUseCase
    private let fetchMovieGenresUseCase: any FetchMovieGenresUseCase

    public init(
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase,
        fetchDiscoverMoviesUseCase: some FetchDiscoverMoviesUseCase,
        fetchMovieRecommendationsUseCase: some FetchMovieRecommendationsUseCase,
        fetchMovieGenresUseCase: some FetchMovieGenresUseCase
    ) {
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
        self.fetchDiscoverMoviesUseCase = fetchDiscoverMoviesUseCase
        self.fetchMovieRecommendationsUseCase = fetchMovieRecommendationsUseCase
        self.fetchMovieGenresUseCase = fetchMovieGenresUseCase
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

    public func makeMovieProvider() -> some MovieProviding {
        MovieProviderAdapter(
            fetchDiscoverMoviesUseCase: fetchDiscoverMoviesUseCase,
            fetchMovieRecommendationsUseCase: fetchMovieRecommendationsUseCase
        )
    }

    public func makeGenreProvider() -> some GenreProviding {
        GenreProviderAdapter(fetchMovieGenresUseCase: fetchMovieGenresUseCase)
    }

}
