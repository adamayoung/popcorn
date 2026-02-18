//
//  LivePopcornMoviesFactory.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication
import MoviesDomain
import MoviesInfrastructure

public final class LivePopcornMoviesFactory: PopcornMoviesFactory {

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
            movieCreditsRepository: infrastructureFactory.makeMovieCreditsRepository(),
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchMovieDetailsUseCase() -> FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }

    public func makeStreamMovieDetailsUseCase() -> StreamMovieDetailsUseCase {
        applicationFactory.makeStreamMovieDetailsUseCase()
    }

    public func makeToggleWatchlistMovieUseCase() -> ToggleWatchlistMovieUseCase {
        applicationFactory.makeToggleWatchlistMovieUseCase()
    }

    public func makeFetchMovieImageCollectionUseCase() -> FetchMovieImageCollectionUseCase {
        applicationFactory.makeFetchMovieImageCollectionUseCase()
    }

    public func makeFetchPopularMoviesUseCase() -> FetchPopularMoviesUseCase {
        applicationFactory.makeFetchPopularMoviesUseCase()
    }

    public func makeStreamPopularMoviesUseCase() -> StreamPopularMoviesUseCase {
        applicationFactory.makeStreamPopularMoviesUseCase()
    }

    public func makeFetchSimilarMoviesUseCase() -> FetchSimilarMoviesUseCase {
        applicationFactory.makeFetchSimilarMoviesUseCase()
    }

    public func makeStreamSimilarMoviesUseCase() -> StreamSimilarMoviesUseCase {
        applicationFactory.makeStreamSimilarMoviesUseCase()
    }

    public func makeFetchMovieRecommendationsUseCase() -> FetchMovieRecommendationsUseCase {
        applicationFactory.makeFetchMovieRecommendationsUseCase()
    }

    public func makeStreamMovieRecommendationsUseCase() -> StreamMovieRecommendationsUseCase {
        applicationFactory.makeStreamMovieRecommendationsUseCase()
    }

    public func makeFetchMovieCreditsUseCase() -> FetchMovieCreditsUseCase {
        applicationFactory.makeFetchMovieCreditsUseCase()
    }

    public func makeStreamWatchlistMoviesUseCase() -> StreamWatchlistMoviesUseCase {
        applicationFactory.makeStreamWatchlistMoviesUseCase()
    }

    public func makeFetchWatchlistMoviesUseCase() -> FetchWatchlistMoviesUseCase {
        applicationFactory.makeFetchWatchlistMoviesUseCase()
    }

}
