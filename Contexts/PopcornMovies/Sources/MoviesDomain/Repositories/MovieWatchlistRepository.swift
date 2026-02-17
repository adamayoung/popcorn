//
//  MovieWatchlistRepository.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Defines the contract for managing a user's movie watchlist.
///
/// This repository provides methods to retrieve, add, and remove movies from
/// a user's personal watchlist. Implementations may persist data locally, sync
/// with remote services, or use a combination of both approaches.
///
public protocol MovieWatchlistRepository: Sendable {

    ///
    /// Fetches all movies currently on the user's watchlist.
    ///
    /// - Returns: A set of ``WatchlistMovie`` instances representing the user's watchlist.
    /// - Throws: ``MovieWatchlistRepositoryError`` if the watchlist cannot be retrieved.
    ///
    func movies() async throws(MovieWatchlistRepositoryError) -> Set<WatchlistMovie>

    ///
    /// Checks whether a specific movie is on the user's watchlist.
    ///
    /// - Parameter id: The unique identifier of the movie to check.
    /// - Returns: `true` if the movie is on the watchlist, `false` otherwise.
    /// - Throws: ``MovieWatchlistRepositoryError`` if the watchlist status cannot be determined.
    ///
    func isOnWatchlist(movieID id: Int) async throws(MovieWatchlistRepositoryError) -> Bool

    ///
    /// Adds a movie to the user's watchlist.
    ///
    /// - Parameter id: The unique identifier of the movie to add.
    /// - Throws: ``MovieWatchlistRepositoryError`` if the movie cannot be added.
    ///
    func addMovie(withID id: Int) async throws(MovieWatchlistRepositoryError)

    ///
    /// Removes a movie from the user's watchlist.
    ///
    /// - Parameter id: The unique identifier of the movie to remove.
    /// - Throws: ``MovieWatchlistRepositoryError`` if the movie cannot be removed.
    ///
    func removeMovie(withID id: Int) async throws(MovieWatchlistRepositoryError)

}

///
/// Errors that can occur when accessing or modifying a movie watchlist through a repository.
///
public enum MovieWatchlistRepositoryError: Error {

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
