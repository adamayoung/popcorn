//
//  UITestPopcornMoviesFactory.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication
import MoviesComposition
import MoviesDomain

public final class UITestPopcornMoviesFactory: PopcornMoviesFactory {

    private let applicationFactory: MoviesApplicationFactory

    public init() {
        self.applicationFactory = MoviesApplicationFactory(
            movieRepository: StubMovieRepository(),
            movieWatchlistRepository: StubMovieWatchlistRepository(),
            movieImageRepository: StubMovieImageRepository(),
            popularMovieRepository: StubPopularMovieRepository(),
            similarMovieRepository: StubSimilarMovieRepository(),
            movieRecommendationRepository: StubMovieRecommendationRepository(),
            movieCreditsRepository: StubMovieCreditsRepository(),
            appConfigurationProvider: StubAppConfigurationProvider()
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

}
