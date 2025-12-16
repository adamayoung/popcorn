//
//  PopcornMoviesFactory.swift
//  PopcornMovies
//
//  Created by Adam Young on 15/12/2025.
//

import Foundation
import MoviesApplication
import MoviesDomain
import MoviesInfrastructure

public struct PopcornMoviesFactory {

    private let applicationFactory: MoviesApplicationFactory

    public init(
        movieRemoteDataSource: some MovieRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructureFactory = MoviesInfrastructureFactory(
            movieRemoteDataSource: movieRemoteDataSource
        )
        self.applicationFactory = MoviesApplicationFactory(
            movieRepository: infrastructureFactory.makeMovieRepository(),
            favouriteMovieRepository: infrastructureFactory.makeFavouriteMovieRepository(),
            movieImageRepository: infrastructureFactory.makeMovieImageRepository(),
            popularMovieRepository: infrastructureFactory.makePopularMovieRepository(),
            similarMovieRepository: infrastructureFactory.makeSimilarMovieRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }

    public func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        applicationFactory.makeStreamMovieDetailsUseCase()
    }

    public func makeToggleFavouriteMovieUseCase() -> some ToggleFavouriteMovieUseCase {
        applicationFactory.makeToggleFavouriteMovieUseCase()
    }

    public func makeFetchMovieImageCollectionUseCase() -> some FetchMovieImageCollectionUseCase {
        applicationFactory.makeFetchMovieImageCollectionUseCase()
    }

    public func makeFetchPopularMoviesUseCase() -> some FetchPopularMoviesUseCase {
        applicationFactory.makeFetchPopularMoviesUseCase()
    }

    public func makeStreamPopularMoviesUseCase() -> some StreamPopularMoviesUseCase {
        applicationFactory.makeStreamPopularMoviesUseCase()
    }

    public func makeFetchSimilarMoviesUseCase() -> some FetchSimilarMoviesUseCase {
        applicationFactory.makeFetchSimilarMoviesUseCase()
    }

    public func makeStreamSimilarMoviesUseCase() -> some StreamSimilarMoviesUseCase {
        applicationFactory.makeStreamSimilarMoviesUseCase()
    }

}
