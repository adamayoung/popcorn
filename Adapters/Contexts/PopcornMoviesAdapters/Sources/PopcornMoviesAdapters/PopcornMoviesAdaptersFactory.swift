//
//  PopcornMoviesAdaptersFactory.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import Foundation
import MoviesComposition
import TMDb

public final class PopcornMoviesAdaptersFactory {

    private let movieService: any MovieService
    private let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    public init(
        movieService: some MovieService,
        fetchAppConfigurationUseCase: some FetchAppConfigurationUseCase
    ) {
        self.movieService = movieService
        self.fetchAppConfigurationUseCase = fetchAppConfigurationUseCase
    }

    public func makeMoviesFactory() -> some PopcornMoviesFactory {
        let movieRemoteDataSource = TMDbMovieRemoteDataSource(movieService: movieService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return LivePopcornMoviesFactory(
            movieRemoteDataSource: movieRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
