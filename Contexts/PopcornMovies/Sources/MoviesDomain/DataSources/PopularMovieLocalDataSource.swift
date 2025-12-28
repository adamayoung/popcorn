//
//  PopularMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of popular movies data.
///
/// This data source provides methods to read and write cached popular movie data,
/// including pagination support. Implementations typically use SwiftData or other
/// persistence mechanisms.
///
public protocol PopularMovieLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves cached popular movies for a specific page.
    ///
    /// - Parameter page: The page number to retrieve (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances if cached, or `nil` if not available.
    /// - Throws: ``PopularMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func popular(page: Int) async throws(PopularMovieLocalDataSourceError) -> [MoviePreview]?

    ///
    /// Creates a stream that emits cached popular movies data.
    ///
    /// The stream emits updates whenever the cached data changes, enabling reactive UI updates.
    ///
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` or `nil`.
    ///
    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Returns the current page number for the popular movies stream.
    ///
    /// - Returns: The current page number, or `nil` if no pages have been loaded.
    /// - Throws: ``PopularMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func currentPopularStreamPage() async throws(PopularMovieLocalDataSourceError) -> Int?

    ///
    /// Caches popular movies for a specific page.
    ///
    /// - Parameters:
    ///   - moviePreviews: The movie previews to cache.
    ///   - page: The page number being cached (1-indexed).
    /// - Throws: ``PopularMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func setPopular(
        _ moviePreviews: [MoviePreview],
        page: Int
    ) async throws(PopularMovieLocalDataSourceError)

}

///
/// Errors that can occur when accessing local popular movies data.
///
public enum PopularMovieLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
