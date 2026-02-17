//
//  FetchSimilarMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol FetchSimilarMoviesUseCase: Sendable {

    func execute(
        movieID: Movie.ID
    ) async throws(FetchSimilarMoviesError) -> [MoviePreviewDetails]

    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchSimilarMoviesError) -> [MoviePreviewDetails]

}
