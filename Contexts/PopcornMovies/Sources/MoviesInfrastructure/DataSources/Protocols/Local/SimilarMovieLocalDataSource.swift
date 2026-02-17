//
//  SimilarMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public protocol SimilarMovieLocalDataSource: Sendable, Actor {

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError) -> [MoviePreview]?

    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func currentSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieLocalDataSourceError) -> Int?

    func setSimilar(
        _ moviePreviews: [MoviePreview],
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError)

}

public enum SimilarMovieLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
