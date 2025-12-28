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

///
/// Factory for creating use cases in the PopcornMovies module.
///
/// This factory provides the public entry point for the movies feature, creating
/// fully configured use cases with all required dependencies. It handles the
/// composition of application and infrastructure layers internally.
///
/// Use this factory to obtain use cases for movie-related operations:
/// - Fetching and streaming movie details
/// - Managing the user's watchlist
/// - Fetching and streaming popular, similar, and recommended movies
///
public struct PopcornMoviesFactory {

    private let applicationFactory: MoviesApplicationFactory

    ///
    /// Creates a new PopcornMovies factory.
    ///
    /// - Parameters:
    ///   - movieRemoteDataSource: The data source for fetching movie data from a remote API.
    ///   - appConfigurationProvider: The provider for application configuration.
    ///
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

    /// Creates a use case for fetching comprehensive movie details.
    public func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }

    /// Creates a use case for streaming real-time movie details updates.
    public func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        applicationFactory.makeStreamMovieDetailsUseCase()
    }

    /// Creates a use case for toggling a movie's watchlist status.
    public func makeToggleWatchlistMovieUseCase() -> some ToggleWatchlistMovieUseCase {
        applicationFactory.makeToggleWatchlistMovieUseCase()
    }

    /// Creates a use case for fetching a movie's image collection.
    public func makeFetchMovieImageCollectionUseCase() -> some FetchMovieImageCollectionUseCase {
        applicationFactory.makeFetchMovieImageCollectionUseCase()
    }

    /// Creates a use case for fetching popular movies.
    public func makeFetchPopularMoviesUseCase() -> some FetchPopularMoviesUseCase {
        applicationFactory.makeFetchPopularMoviesUseCase()
    }

    /// Creates a use case for streaming real-time popular movies updates.
    public func makeStreamPopularMoviesUseCase() -> some StreamPopularMoviesUseCase {
        applicationFactory.makeStreamPopularMoviesUseCase()
    }

    /// Creates a use case for fetching similar movies.
    public func makeFetchSimilarMoviesUseCase() -> some FetchSimilarMoviesUseCase {
        applicationFactory.makeFetchSimilarMoviesUseCase()
    }

    /// Creates a use case for streaming real-time similar movies updates.
    public func makeStreamSimilarMoviesUseCase() -> some StreamSimilarMoviesUseCase {
        applicationFactory.makeStreamSimilarMoviesUseCase()
    }

    /// Creates a use case for fetching movie recommendations.
    public func makeFetchMovieRecommendationsUseCase() -> some FetchMovieRecommendationsUseCase {
        applicationFactory.makeFetchMovieRecommendationsUseCase()
    }

    /// Creates a use case for streaming real-time movie recommendations updates.
    public func makeStreamMovieRecommendationsUseCase() -> some StreamMovieRecommendationsUseCase {
        applicationFactory.makeStreamMovieRecommendationsUseCase()
    }

}
