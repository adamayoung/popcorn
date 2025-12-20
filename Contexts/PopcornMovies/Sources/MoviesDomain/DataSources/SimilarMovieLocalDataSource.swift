//
//  SimilarMovieLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol SimilarMovieLocalDataSource: Sendable, Actor {

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError) -> [MoviePreview]?

    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func currentSimilarStreamPage() async throws(SimilarMovieLocalDataSourceError) -> Int?

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
