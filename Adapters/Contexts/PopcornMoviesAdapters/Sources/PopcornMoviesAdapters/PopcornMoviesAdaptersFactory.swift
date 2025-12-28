//
//  PopcornMoviesAdaptersFactory.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation
import MoviesComposition
import TMDb

///
/// A factory for creating movie-related adapters.
///
/// Creates adapters that bridge TMDb movie services to the application's
/// movies domain.
///
public final class PopcornMoviesAdaptersFactory {

    private let movieService: any MovieService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    ///
    /// Creates a movies adapters factory.
    ///
    /// - Parameters:
    ///   - movieService: The TMDb movie service.
    ///   - fetchAppConfigurationUseCase: The use case for fetching app configuration.
    ///
    public init(
        movieService: some MovieService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.movieService = movieService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    ///
    /// Creates a movies factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornMoviesFactory`` instance.
    ///
    public func makeMoviesFactory() -> PopcornMoviesFactory {
        let movieRemoteDataSource = TMDbMovieRemoteDataSource(movieService: movieService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return PopcornMoviesFactory(
            movieRemoteDataSource: movieRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
