//
//  DiscoverMovieLocalDataSource.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of discovered movies.
///
/// Implementations of this protocol handle caching and retrieval of movie
/// previews from local storage, enabling offline access and reducing
/// network requests.
///
public protocol DiscoverMovieLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves a page of cached movies matching the specified filter.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to match. Pass `nil` for no filtering.
    ///   - page: The page number to retrieve (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances if cached data exists, or `nil` if no cache is available.
    /// - Throws: ``DiscoverMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError) -> [MoviePreview]?

    ///
    /// Creates an async stream that emits cached movies whenever the local store changes.
    ///
    /// - Parameter filter: Optional filter criteria to match. Pass `nil` for no filtering.
    /// - Returns: An ``AsyncThrowingStream`` that emits arrays of ``MoviePreview`` or `nil` when no data is available.
    ///
    func moviesStream(
        filter: MovieFilter?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Retrieves the highest page number currently cached for the given filter.
    ///
    /// - Parameter filter: Optional filter criteria to match. Pass `nil` for no filtering.
    /// - Returns: The highest cached page number, or `nil` if no pages are cached.
    /// - Throws: ``DiscoverMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func currentMoviesStreamPage(
        filter: MovieFilter?
    ) async throws(DiscoverMovieLocalDataSourceError) -> Int?

    ///
    /// Stores a page of movie previews in the local cache.
    ///
    /// - Parameters:
    ///   - moviePreviews: The array of ``MoviePreview`` instances to cache.
    ///   - filter: Optional filter criteria associated with this data. Pass `nil` for no filtering.
    ///   - page: The page number this data represents (1-indexed).
    /// - Throws: ``DiscoverMovieLocalDataSourceError`` if the data cannot be persisted.
    ///
    func setMovies(
        _ moviePreviews: [MoviePreview],
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverMovieLocalDataSourceError)

}

///
/// Errors that can occur when accessing the local movie data source.
///
public enum DiscoverMovieLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
