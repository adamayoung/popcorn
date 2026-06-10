//
//  PopcornMoviesAdaptersFactory.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import MoviesDomain
import MoviesInfrastructure
import TMDb

/// Builds the Movies context's TMDb-backed adapters (port implementations).
public final class PopcornMoviesAdaptersFactory {

    private let movieService: any TMDb.MovieService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        movieService: some TMDb.MovieService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.movieService = movieService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeMovieRemoteDataSource() -> some MovieRemoteDataSource {
        TMDbMovieRemoteDataSource(movieService: movieService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }

}
