//
//  MoviesComposition.swift
//  MoviesKit
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure

public struct MoviesComposition {

    private init() {}

    public static func makeMoviesFactory(
        movieRemoteDataSource: some MovieRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) -> MoviesApplicationFactory {
        let infrastructureFactory = MoviesInfrastructureFactory(
            movieRemoteDataSource: movieRemoteDataSource
        )

        return MoviesApplicationFactory(
            movieRepository: infrastructureFactory.makeMovieRepository(),
            favouriteMovieRepository: infrastructureFactory.makeFavouriteMovieRepository(),
            movieImageRepository: infrastructureFactory.makeMovieImageRepository(),
            popularMovieRepository: infrastructureFactory.makePopularMovieRepository(),
            similarMovieRepository: infrastructureFactory.makeSimilarMovieRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
