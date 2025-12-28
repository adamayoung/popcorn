//
//  GenreLocalDataSource.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local storage of genre data.
///
/// This data source provides actor-isolated access to cached genre information,
/// supporting both movie and TV series genres. Implementations handle persistence
/// to local storage mechanisms such as in-memory caches or disk-based storage.
///
public protocol GenreLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves cached movie genres from local storage.
    ///
    /// - Returns: An array of ``Genre`` instances if cached data exists, or `nil` if no cache is available.
    /// - Throws: ``GenreLocalDataSourceError`` if the retrieval operation fails.
    ///
    func movieGenres() async throws(GenreLocalDataSourceError) -> [Genre]?

    ///
    /// Stores movie genres in local storage.
    ///
    /// - Parameter genres: The array of ``Genre`` instances to cache.
    /// - Throws: ``GenreLocalDataSourceError`` if the storage operation fails.
    ///
    func setMovieGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError)

    ///
    /// Retrieves cached TV series genres from local storage.
    ///
    /// - Returns: An array of ``Genre`` instances if cached data exists, or `nil` if no cache is available.
    /// - Throws: ``GenreLocalDataSourceError`` if the retrieval operation fails.
    ///
    func tvSeriesGenres() async throws(GenreLocalDataSourceError) -> [Genre]?

    ///
    /// Stores TV series genres in local storage.
    ///
    /// - Parameter genres: The array of ``Genre`` instances to cache.
    /// - Throws: ``GenreLocalDataSourceError`` if the storage operation fails.
    ///
    func setTVSeriesGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError)

}

///
/// Errors that can occur when accessing genre data from local storage.
///
public enum GenreLocalDataSourceError: Error {

    /// A persistence operation failed, wrapping the underlying error.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
