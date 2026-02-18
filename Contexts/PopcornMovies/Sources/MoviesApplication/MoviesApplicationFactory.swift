//
//  MoviesApplicationFactory.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public final class MoviesApplicationFactory: Sendable {

    private let movieRepository: any MovieRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let movieImageRepository: any MovieImageRepository
    private let popularMovieRepository: any PopularMovieRepository
    private let similarMovieRepository: any SimilarMovieRepository
    private let movieRecommendationRepository: any MovieRecommendationRepository
    private let movieCreditsRepository: any MovieCreditsRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    public init(
        movieRepository: some MovieRepository,
        movieWatchlistRepository: some MovieWatchlistRepository,
        movieImageRepository: some MovieImageRepository,
        popularMovieRepository: some PopularMovieRepository,
        similarMovieRepository: some SimilarMovieRepository,
        movieRecommendationRepository: some MovieRecommendationRepository,
        movieCreditsRepository: some MovieCreditsRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.movieImageRepository = movieImageRepository
        self.popularMovieRepository = popularMovieRepository
        self.similarMovieRepository = similarMovieRepository
        self.movieRecommendationRepository = movieRecommendationRepository
        self.movieCreditsRepository = movieCreditsRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    public func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        DefaultStreamMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeToggleWatchlistMovieUseCase() -> some ToggleWatchlistMovieUseCase {
        DefaultToggleWatchlistMovieUseCase(
            movieRepository: movieRepository,
            movieWatchlistRepository: movieWatchlistRepository
        )
    }

    public func makeFetchMovieImageCollectionUseCase() -> some FetchMovieImageCollectionUseCase {
        DefaultFetchMovieImageCollectionUseCase(
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchPopularMoviesUseCase() -> some FetchPopularMoviesUseCase {
        DefaultFetchPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamPopularMoviesUseCase() -> some StreamPopularMoviesUseCase {
        DefaultStreamPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchSimilarMoviesUseCase() -> some FetchSimilarMoviesUseCase {
        DefaultFetchSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamSimilarMoviesUseCase() -> some StreamSimilarMoviesUseCase {
        DefaultStreamSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchMovieRecommendationsUseCase() -> some FetchMovieRecommendationsUseCase {
        DefaultFetchMovieRecommendationsUseCase(
            movieRecommendationRepository: movieRecommendationRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamMovieRecommendationsUseCase() -> some StreamMovieRecommendationsUseCase {
        DefaultStreamMovieRecommendationsUseCase(
            movieRecommendationRepository: movieRecommendationRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchMovieCreditsUseCase() -> some FetchMovieCreditsUseCase {
        DefaultFetchMovieCreditsUseCase(
            movieCreditsRepository: movieCreditsRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeStreamWatchlistMoviesUseCase() -> some StreamWatchlistMoviesUseCase {
        DefaultStreamWatchlistMoviesUseCase(
            movieRepository: movieRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    public func makeFetchWatchlistMoviesUseCase() -> some FetchWatchlistMoviesUseCase {
        DefaultFetchWatchlistMoviesUseCase(
            movieRepository: movieRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
