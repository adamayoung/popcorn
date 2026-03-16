//
//  MoviesApplicationFactory.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

package final class MoviesApplicationFactory: Sendable {

    private let movieRepository: any MovieRepository
    private let movieWatchlistRepository: any MovieWatchlistRepository
    private let movieImageRepository: any MovieImageRepository
    private let popularMovieRepository: any PopularMovieRepository
    private let similarMovieRepository: any SimilarMovieRepository
    private let movieRecommendationRepository: any MovieRecommendationRepository
    private let movieCreditsRepository: any MovieCreditsRepository
    private let movieWatchProvidersRepository: any MovieWatchProvidersRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    package init(
        movieRepository: some MovieRepository,
        movieWatchlistRepository: some MovieWatchlistRepository,
        movieImageRepository: some MovieImageRepository,
        popularMovieRepository: some PopularMovieRepository,
        similarMovieRepository: some SimilarMovieRepository,
        movieRecommendationRepository: some MovieRecommendationRepository,
        movieCreditsRepository: some MovieCreditsRepository,
        movieWatchProvidersRepository: some MovieWatchProvidersRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.movieRepository = movieRepository
        self.movieWatchlistRepository = movieWatchlistRepository
        self.movieImageRepository = movieImageRepository
        self.popularMovieRepository = popularMovieRepository
        self.similarMovieRepository = similarMovieRepository
        self.movieRecommendationRepository = movieRecommendationRepository
        self.movieCreditsRepository = movieCreditsRepository
        self.movieWatchProvidersRepository = movieWatchProvidersRepository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
    }

    package func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeStreamMovieDetailsUseCase() -> some StreamMovieDetailsUseCase {
        DefaultStreamMovieDetailsUseCase(
            movieRepository: movieRepository,
            movieImageRepository: movieImageRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
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
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeStreamPopularMoviesUseCase() -> some StreamPopularMoviesUseCase {
        DefaultStreamPopularMoviesUseCase(
            popularMovieRepository: popularMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchSimilarMoviesUseCase() -> some FetchSimilarMoviesUseCase {
        DefaultFetchSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeStreamSimilarMoviesUseCase() -> some StreamSimilarMoviesUseCase {
        DefaultStreamSimilarMoviesUseCase(
            similarMovieRepository: similarMovieRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchMovieRecommendationsUseCase() -> some FetchMovieRecommendationsUseCase {
        DefaultFetchMovieRecommendationsUseCase(
            movieRecommendationRepository: movieRecommendationRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeStreamMovieRecommendationsUseCase() -> some StreamMovieRecommendationsUseCase {
        DefaultStreamMovieRecommendationsUseCase(
            movieRecommendationRepository: movieRecommendationRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchMovieCreditsUseCase() -> some FetchMovieCreditsUseCase {
        DefaultFetchMovieCreditsUseCase(
            movieCreditsRepository: movieCreditsRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeFetchMovieWatchProvidersUseCase() -> some FetchMovieWatchProvidersUseCase {
        DefaultFetchMovieWatchProvidersUseCase(
            movieWatchProvidersRepository: movieWatchProvidersRepository,
            appConfigurationProvider: appConfigurationProvider
        )
    }

    package func makeStreamWatchlistMoviesUseCase() -> some StreamWatchlistMoviesUseCase {
        DefaultStreamWatchlistMoviesUseCase(
            movieRepository: movieRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

    package func makeFetchWatchlistMoviesUseCase() -> some FetchWatchlistMoviesUseCase {
        DefaultFetchWatchlistMoviesUseCase(
            movieRepository: movieRepository,
            movieWatchlistRepository: movieWatchlistRepository,
            movieImageRepository: movieImageRepository,
            appConfigurationProvider: appConfigurationProvider,
            themeColorProvider: themeColorProvider
        )
    }

}
