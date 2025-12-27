//
//  MovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing and managing movie data.
///
/// This repository provides methods to fetch movie information either as a single
/// asynchronous call or as a continuous stream of updates. Implementations may
/// retrieve data from remote APIs, local caches, or a combination of both.
///
public protocol MovieRepository: Sendable {

    ///
    /// Fetches detailed information for a specific movie.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the movie to fetch.
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: A ``Movie`` instance containing the movie's details.
    /// - Throws: ``MovieRepositoryError`` if the movie cannot be fetched.
    ///
    func movie(
        withID id: Int,
        cachePolicy: CachePolicy
    ) async throws(MovieRepositoryError) -> Movie

    ///
    /// Creates a stream that continuously emits updates for a specific movie.
    ///
    /// This stream is useful for observing changes to movie data over time,
    /// such as cache updates or background synchronization.
    ///
    /// - Parameter id: The unique identifier of the movie to observe.
    /// - Returns: An async throwing stream that emits ``Movie`` instances or `nil` if not available.
    ///
    func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error>

}

///
/// Errors that can occur when accessing movie data through a repository.
///
public extension MovieRepository {

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        try await movie(withID: id, cachePolicy: .cacheFirst)
    }

}

public enum MovieRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The requested movie was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
