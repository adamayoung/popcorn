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
    /// - Parameter id: The unique identifier of the movie to fetch.
    /// - Returns: A ``Movie`` instance containing the movie's details.
    /// - Throws: ``MovieRepositoryError`` if the movie cannot be fetched.
    ///
    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie

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

    func certification(forMovie movieID: Int) async throws(MovieRepositoryError) -> String

}

///
/// Errors that can occur when accessing movie data through a repository.
///
public enum MovieRepositoryError: Error {

    /// The requested movie was not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
