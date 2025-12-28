//
//  MovieWatchlistLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of movie watchlist data.
///
/// This data source provides methods to manage a user's movie watchlist locally,
/// including adding, removing, and querying watchlist items. Implementations typically
/// use SwiftData with CloudKit synchronization.
///
public protocol MovieWatchlistLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves all movies on the user's watchlist.
    ///
    /// - Returns: A set of ``WatchlistMovie`` instances.
    /// - Throws: ``MovieWatchlistLocalDataSourceError`` if a persistence error occurs.
    ///
    func movies() async throws(MovieWatchlistLocalDataSourceError) -> Set<WatchlistMovie>

    ///
    /// Checks whether a specific movie is on the user's watchlist.
    ///
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: `true` if the movie is on the watchlist, `false` otherwise.
    /// - Throws: ``MovieWatchlistLocalDataSourceError`` if a persistence error occurs.
    ///
    func isOnWatchlist(
        movieID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError) -> Bool

    ///
    /// Adds a movie to the user's watchlist.
    ///
    /// - Parameter id: The unique identifier of the movie to add.
    /// - Throws: ``MovieWatchlistLocalDataSourceError`` if a persistence error occurs.
    ///
    func addMovie(
        withID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError)

    ///
    /// Removes a movie from the user's watchlist.
    ///
    /// - Parameter id: The unique identifier of the movie to remove.
    /// - Throws: ``MovieWatchlistLocalDataSourceError`` if a persistence error occurs.
    ///
    func removeMovie(
        withID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError)

}

///
/// Errors that can occur when accessing local movie watchlist data.
///
public enum MovieWatchlistLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
