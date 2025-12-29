//
//  MovieRecommendationLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for local persistence of movie recommendations.
///
/// This data source provides methods to read and write cached movie recommendations,
/// enabling offline access and reducing network requests. Implementations typically
/// use SwiftData or other persistence mechanisms.
///
public protocol MovieRecommendationLocalDataSource: Sendable, Actor {

    ///
    /// Retrieves cached recommendations for a specific movie and page.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to retrieve (1-indexed).
    /// - Returns: An array of ``MoviePreview`` instances if cached, or `nil` if not available.
    /// - Throws: ``MovieRecommendationLocalDataSourceError`` if a persistence error occurs.
    ///
    func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationLocalDataSourceError) -> [MoviePreview]?

    ///
    /// Creates a stream that emits cached recommendations for a specific movie.
    ///
    /// The stream emits updates whenever the cached data changes, enabling reactive UI updates.
    /// Use ``nextRecommendationsStreamPage(forMovie:)`` to load additional pages.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - limit: The maximum number of recommendations to return, or `nil` for no limit.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` or `nil`.
    ///
    func recommendationsStream(
        forMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Returns the current page number for the recommendations stream.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///
    /// - Returns: The current page number, or `nil` if no pages have been loaded.
    ///
    /// - Throws: ``MovieRecommendationLocalDataSourceError`` if a persistence error occurs.
    ///
    func currentRecommendationsStreamPage(
        forMovie movieID: Int
    ) async throws(MovieRecommendationLocalDataSourceError) -> Int?

    ///
    /// Caches recommendations for a specific movie and page.
    ///
    /// This method replaces any existing cached data for the given page and all subsequent pages.
    ///
    /// - Parameters:
    ///   - moviePreviews: The movie previews to cache.
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number being cached (1-indexed).
    /// - Throws: ``MovieRecommendationLocalDataSourceError`` if a persistence error occurs.
    ///
    func setRecommendations(
        _ moviePreviews: [MoviePreview],
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationLocalDataSourceError)

}

///
/// Errors that can occur when accessing local movie recommendations data.
///
public enum MovieRecommendationLocalDataSourceError: Error {

    /// A persistence layer error occurred.
    case persistence(Error)

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
