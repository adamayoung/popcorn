//
//  SimilarMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of similar movies data.
///
/// This data source provides methods to read and write cached similar movie data,
/// enabling offline access and reducing network requests. Implementations typically
/// use SwiftData or other persistence mechanisms.
///
public protocol SimilarMovieLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves cached similar movies for a specific movie and page.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to retrieve (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances if cached, or `nil` if not available.
    /// - Throws: ``SimilarMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError) -> [MoviePreview]?

    ///
    /// Creates a stream that emits cached similar movies for a specific movie.
    ///
    /// The stream emits updates whenever the cached data changes, enabling reactive UI updates.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - limit: The maximum number of movies to return, or `nil` for no limit.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` or `nil`.
    ///
    func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Returns the current page number for the similar movies stream.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: The current page number, or `nil` if no pages have been loaded.
    /// - Throws: ``SimilarMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func currentSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieLocalDataSourceError) -> Int?

    ///
    /// Caches similar movies for a specific movie and page.
    ///
    /// - Parameters:
    ///   - moviePreviews: The movie previews to cache.
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number being cached (1-indexed).
    /// - Throws: ``SimilarMovieLocalDataSourceError`` if a persistence error occurs.
    ///
    func setSimilar(
        _ moviePreviews: [MoviePreview],
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieLocalDataSourceError)

}

///
/// Errors that can occur when accessing local similar movies data.
///
public enum SimilarMovieLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
