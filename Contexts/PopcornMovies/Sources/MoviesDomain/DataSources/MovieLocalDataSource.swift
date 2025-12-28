//
//  MovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of movie data.
///
/// This data source provides methods to read and write cached movie data,
/// enabling offline access and reducing network requests. Implementations
/// typically use SwiftData or other persistence mechanisms.
///
public protocol MovieLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves a cached movie by its identifier.
    ///
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: A ``Movie`` instance if cached, or `nil` if not available.
    /// - Throws: ``MovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func movie(withID id: Int) async throws(MovieLocalDataSourceError) -> Movie?

    ///
    /// Creates a stream that emits cached movie data for a specific movie.
    ///
    /// The stream emits updates whenever the cached data changes, enabling reactive UI updates.
    ///
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: An async throwing stream that emits ``Movie`` instances or `nil`.
    ///
    func movieStream(forMovie id: Int) async -> AsyncThrowingStream<Movie?, Error>

    ///
    /// Caches a movie in the local data store.
    ///
    /// - Parameter movie: The movie to cache.
    /// - Throws: ``MovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func setMovie(_ movie: Movie) async throws(MovieLocalDataSourceError)

}

///
/// Errors that can occur when accessing local movie data.
///
public enum MovieLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
