//
//  PopularMovieRepository.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Defines the contract for accessing popular movies data.
///
/// This repository provides methods to fetch popular movies, either as paginated
/// results or as a continuous stream of updates. Implementations may retrieve data
/// from remote APIs, local caches, or a combination of both.
///
public protocol PopularMovieRepository: Sendable {

    ///
    /// Fetches a page of popular movies.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch (1-indexed).
    ///   - cachePolicy: The caching strategy to use for this request.
    /// - Returns: An array of ``MoviePreview`` instances representing popular movies.
    /// - Throws: ``PopularMovieRepositoryError`` if the movies cannot be fetched.
    ///
    func popular(
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(PopularMovieRepositoryError) -> [MoviePreview]

    ///
    /// Creates a stream that continuously emits updates of popular movies.
    ///
    /// This stream is useful for observing changes to popular movies over time,
    /// such as cache updates or background synchronization. The stream automatically
    /// manages pagination and can be advanced using ``nextPopularStreamPage()``.
    ///
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreview`` instances or `nil` if not available.
    ///
    func popularStream() async -> AsyncThrowingStream<[MoviePreview]?, Error>

    ///
    /// Advances the popular movies stream to the next page.
    ///
    /// This method should be called to load more movies when using ``popularStream()``.
    /// It triggers the stream to emit the next page of popular movies.
    ///
    /// - Throws: ``PopularMovieRepositoryError`` if the next page cannot be fetched.
    ///
    func nextPopularStreamPage() async throws(PopularMovieRepositoryError)

}

///
/// Errors that can occur when accessing popular movies data through a repository.
///
extension PopularMovieRepository {

    public func popular(page: Int) async throws(PopularMovieRepositoryError) -> [MoviePreview] {
        try await popular(page: page, cachePolicy: .cacheFirst)
    }

}

public enum PopularMovieRepositoryError: Error {

    /// No cached data is available for the request.
    case cacheUnavailable

    /// The requested popular movies were not found.
    case notFound

    /// The request was not authorized.
    case unauthorised

    /// An unknown error occurred, optionally wrapping an underlying error.
    case unknown(Error? = nil)

}
