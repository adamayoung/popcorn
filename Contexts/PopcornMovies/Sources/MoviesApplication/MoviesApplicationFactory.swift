//
//  MoviesApplicationFactory.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

package final class MoviesApplicationFactory {

    private let movieRepository: any MovieRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let movieImageRepository: any MovieImageRepository
    private let popularMovieRepository: any PopularMovieRepository
    private let similarMovieRepository: any SimilarMovieRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    package init(
        movieRepository: some MovieRepository,
        movieWatchlistRepository: some MovieWatchlistRepository,
        movieImageRepository: some MovieImageRepository,
        popularMovieRepository: some PopularMovieRepository,
        similarMovieRepository: some SimilarMovieRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.movieRepository = movieRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.movieImageRepository = movieImageRepository
        self.popularMovieRepository = popularMovieRepository
        self.similarMovieRepository = similarMovieRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    package func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        DefaultStreamMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeToggleWatchlistMovieUseCase() -> some ToggleWatchlistMovieUseCase {
        DefaultToggleWatchlistMovieUseCase(
            movieRepository: movieRepository,
            movieWatchlistRepository: movieWatchlistRepository
        )
    }

    package func makeFetchMovieImageCollectionUseCase() -> some FetchMovieImageCollectionUseCase {
        DefaultFetchMovieImageCollectionUseCase(
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchPopularMoviesUseCase() -> some FetchPopularMoviesUseCase {
        DefaultFetchPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeStreamPopularMoviesUseCase() -> some StreamPopularMoviesUseCase {
        DefaultStreamPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchSimilarMoviesUseCase() -> some FetchSimilarMoviesUseCase {
        DefaultFetchSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeStreamSimilarMoviesUseCase() -> some StreamSimilarMoviesUseCase {
        DefaultStreamSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

}
