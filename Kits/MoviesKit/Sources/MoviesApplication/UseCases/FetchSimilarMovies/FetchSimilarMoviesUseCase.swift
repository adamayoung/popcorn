//
//  FetchSimilarMoviesUseCase.swift
//  MoviesKit
//
//  Created by Adam Young on 24/11/2025.
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
