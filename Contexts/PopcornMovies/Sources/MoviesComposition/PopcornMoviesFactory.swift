//
//  PopcornMoviesFactory.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
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
            movieWatchlistRepository: infrastructureFactory.makeMovieWatchlistRepository(),
            movieImageRepository: infrastructureFactory.makeMovieImageRepository(),
            popularMovieRepository: infrastructureFactory.makePopularMovieRepository(),
            similarMovieRepository: infrastructureFactory.makeSimilarMovieRepository(),
            movieRecommendationRepository: infrastructureFactory.makeMovieRecommendationRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }

    public func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        applicationFactory.makeStreamMovieDetailsUseCase()
    }

    public func makeToggleWatchlistMovieUseCase() -> some ToggleWatchlistMovieUseCase {
        applicationFactory.makeToggleWatchlistMovieUseCase()
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

    public func makeFetchMovieRecommendationsUseCase() -> some FetchMovieRecommendationsUseCase {
        applicationFactory.makeFetchMovieRecommendationsUseCase()
    }

}
