//
//  MovieRecommendationRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing movie recommendations data.
///
/// This repository provides methods to fetch recommended movies for a given movie,
/// based on user ratings and preferences. Implementations may retrieve data from
/// remote APIs, local caches, or a combination of both.
///
public protocol MovieRecommendationRepository: Sendable {

    ///
    /// Fetches a page of recommended movies for a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances representing recommended movies.
    /// - Throws: ``MovieRecommendationRepositoryError`` if the movies cannot be fetched.
    ///
    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationRepositoryError) -> [MoviePreview]

    ///
    /// Creates a stream that continuously emits updates of recommended movies for a specific movie.
    ///
    /// This stream is useful for observing changes to recommendations over time,
    /// such as cache updates or background synchronization. The stream automatically
    /// manages pagination and can be advanced using ``nextRecommendationsStreamPage(forMovie:)``.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` instances or `nil` if not available.
    ///
    func recommendationsStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Creates a stream that continuously emits updates of recommended movies for a specific movie, with a result
    /// limit.
    ///
    /// This stream is useful for observing changes to recommendations over time,
    /// such as cache updates or background synchronization. The stream automatically
    /// manages pagination and can be advanced using ``nextRecommendationsStreamPage(forMovie:)``.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - limit: The maximum number of movies to return, or `nil` for no limit.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` instances or `nil` if not available.
    ///
    func recommendationsStream(
        forMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Advances the recommendations stream to the next page for a specific movie.
    ///
    /// This method should be called to load more movies when using ``recommendationsStream(forMovie:)``
    /// or ``recommendationsStream(forMovie:limit:)``. It triggers the stream to emit the next page
    /// of recommended movies.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Throws: ``MovieRecommendationRepositoryError`` if the next page cannot be fetched.
    ///
    func nextRecommendationsStreamPage(forMovie movieID: Int) async throws(MovieRecommendationRepositoryError)

}

///
/// Errors that can occur when accessing movie recommendations data through a repository.
///
public enum MovieRecommendationRepositoryError: Error {

    /// The requested movie recommendations were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
