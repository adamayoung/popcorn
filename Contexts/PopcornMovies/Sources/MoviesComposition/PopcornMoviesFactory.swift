//
//  PopcornMoviesFactory.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

public protocol PopcornMoviesFactory: Sendable {

    func makeFetchMovieDetailsUseCase() -> FetchMovieDetailsUseCase

    func makeStreamMovieDetailsUseCase() -> StreamMovieDetailsUseCase

    func makeToggleWatchlistMovieUseCase() -> ToggleWatchlistMovieUseCase

    func makeFetchMovieImageCollectionUseCase() -> FetchMovieImageCollectionUseCase

    func makeFetchPopularMoviesUseCase() -> FetchPopularMoviesUseCase

    func makeStreamPopularMoviesUseCase() -> StreamPopularMoviesUseCase

    func makeFetchSimilarMoviesUseCase() -> FetchSimilarMoviesUseCase

    func makeStreamSimilarMoviesUseCase() -> StreamSimilarMoviesUseCase

    func makeFetchMovieRecommendationsUseCase() -> FetchMovieRecommendationsUseCase

    func makeStreamMovieRecommendationsUseCase() -> StreamMovieRecommendationsUseCase

    func makeFetchMovieCreditsUseCase() -> FetchMovieCreditsUseCase

}
