//
//  MovieImageLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of movie image data.
///
/// This data source provides methods to read and write cached image collections,
/// enabling offline access and reducing network requests. Implementations typically
/// use SwiftData or other persistence mechanisms.
///
public protocol MovieImageLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves a cached image collection for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An ``ImageCollection`` if cached, or `nil` if not available.
    /// - Throws: ``MovieImageLocalDataSourceError`` if a persistence error occurs.
    ///
    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageLocalDataSourceError) -> ImageCollection?

    ///
    /// Creates a stream that emits cached image collection data for a specific movie.
    ///
    /// The stream emits updates whenever the cached data changes, enabling reactive UI updates.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An async throwing stream that emits ``ImageCollection`` instances or `nil`.
    ///
    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error>

    ///
    /// Caches an image collection in the local data store.
    ///
    /// - Parameter imageCollection: The image collection to cache.
    /// - Throws: ``MovieImageLocalDataSourceError`` if a persistence error occurs.
    ///
    func setImageCollection(
        _ imageCollection: ImageCollection
    ) async throws(MovieImageLocalDataSourceError)

}

///
/// Errors that can occur when accessing local movie image data.
///
public enum MovieImageLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
