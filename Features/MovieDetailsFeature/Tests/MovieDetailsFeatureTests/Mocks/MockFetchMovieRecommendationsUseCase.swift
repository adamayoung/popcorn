//
//  MockFetchMovieRecommendationsUseCase.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication

struct MockFetchMovieRecommendationsUseCase: FetchMovieRecommendationsUseCase {

    let movies: [MoviesApplication.MoviePreviewDetails]

    func execute(movieID: Int) async throws(FetchMovieRecommendationsError) -> [MoviesApplication.MoviePreviewDetails] {
        movies
    }

    func execute(
        movieID: Int,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviesApplication.MoviePreviewDetails] {
        movies
    }

}
