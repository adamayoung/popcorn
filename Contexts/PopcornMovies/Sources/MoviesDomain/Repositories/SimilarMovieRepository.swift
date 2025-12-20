//
//  SimilarMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol SimilarMovieRepository: Sendable {

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieRepositoryError) -> [MoviePreview]

    func similarStream(
        toMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    func nextSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieRepositoryError)

}

public enum SimilarMovieRepositoryError: Error {

    case notFound
    case unauthorised
    case unknown(Error? = nil)

}
