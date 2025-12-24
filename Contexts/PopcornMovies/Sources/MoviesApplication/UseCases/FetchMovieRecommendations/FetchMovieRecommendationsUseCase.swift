//
//  FetchMovieRecommendationsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchMovieRecommendationsUseCase: Sendable {

    func execute(
        movieID: Movie.ID
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails]

    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails]

}
