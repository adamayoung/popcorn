//
//  PopcornMoviesAdaptersFactory.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ConfigurationApplication
import Foundation
import MoviesApplication
import TMDb

struct PopcornMoviesAdaptersFactory {

    let movieService: any MovieService
    let fetchAppConfigurationUseCase: any FetchAppConfigurationUseCase

    func makeMoviesFactory() -> MoviesApplicationFactory {
        let movieRemoteDataSource = TMDbMovieRemoteDataSource(movieService: movieService)

        let appConfigurationProvider = AppConfigurationProviderAdapter(
            fetchUseCase: fetchAppConfigurationUseCase
        )

        return MoviesComposition.makeMoviesFactory(
            movieRemoteDataSource: movieRemoteDataSource,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
