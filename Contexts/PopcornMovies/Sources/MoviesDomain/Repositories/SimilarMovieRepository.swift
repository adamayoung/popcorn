//
//  SimilarMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing similar movies data.
///
/// This repository provides methods to fetch movies similar to a given movie,
/// either as paginated results or as a continuous stream of updates. Implementations
/// may retrieve data from remote APIs, local caches, or a combination of both.
///
public protocol SimilarMovieRepository: Sendable {

    ///
    /// Fetches a page of movies similar to a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of ``MoviePreview`` instances representing similar movies.
    /// - Throws: ``SimilarMovieRepositoryError`` if the movies cannot be fetched.
    ///
    func similar(
        toMovie movieID: Int,
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(SimilarMovieRepositoryError) -> [MoviePreview]

    ///
    /// Creates a stream that continuously emits updates of movies similar to a specific movie.
    ///
    /// This stream is useful for observing changes to similar movies over time,
    /// such as cache updates or background synchronization. The stream automatically
    /// manages pagination and can be advanced using ``nextSimilarStreamPage(forMovie:)``.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` instances or `nil` if not available.
    ///
    func similarStream(
        toMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Creates a stream that continuously emits updates of movies similar to a specific movie, with a result limit.
    ///
    /// This stream is useful for observing changes to similar movies over time,
    /// such as cache updates or background synchronization. The stream automatically
    /// manages pagination and can be advanced using ``nextSimilarStreamPage(forMovie:)``.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - limit: The maximum number of movies to return, or `nil` for no limit.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` instances or `nil` if not available.
    ///
    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Advances the similar movies stream to the next page for a specific movie.
    ///
    /// This method should be called to load more movies when using ``similarStream(toMovie:)``
    /// or ``similarStream(toMovie:limit:)``. It triggers the stream to emit the next page
    /// of similar movies.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Throws: ``SimilarMovieRepositoryError`` if the next page cannot be fetched.
    ///
    func nextSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieRepositoryError)

}

///
/// Errors that can occur when accessing similar movies data through a repository.
///
public extension SimilarMovieRepository {

    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieRepositoryError) -> [MoviePreview] {
        try await similar(toMovie: movieID, page: page, cachePolicy: .cacheFirst)
    }

}

public enum SimilarMovieRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The requested similar movies were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
