//
//  StreamSimilarMoviesUseCase.swift
//  MoviesKit
//
//  Created by Adam Young on 02/12/2025.
//

import Foundation
import MoviesDomain

public protocol StreamSimilarMoviesUseCase: Sendable {

    func stream(movieID: Movie.ID) async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    func stream(
        movieID: Movie.ID,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    func loadNextPage(movieID: Movie.ID) async throws(StreamSimilarMoviesError)

}
