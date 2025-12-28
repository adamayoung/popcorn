//
//  StreamPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// A use case that streams real-time updates of popular movies.
///
/// This protocol defines the contract for observing changes to popular movies over time.
/// The stream supports pagination and refresh capabilities for loading additional content.
///
public protocol StreamPopularMoviesUseCase: Sendable {

    ///
    /// Creates a stream that emits popular movies updates.
    ///
    /// The stream will immediately emit the current cached data (if available),
    /// then continue emitting updates as the data changes or new pages are loaded.
    ///
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreviewDetails``.
    ///
    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    ///
    /// Loads the next page of popular movies into the stream.
    ///
    /// Call this method to trigger pagination and load additional movies.
    /// The stream will emit an updated array including the new movies.
    ///
    /// - Throws: ``StreamPopularMoviesError`` if the next page cannot be loaded.
    ///
    func loadNextPage() async throws(StreamPopularMoviesError)

    ///
    /// Refreshes the popular movies data.
    ///
    /// Call this method to reload the data from the beginning.
    ///
    /// - Throws: ``StreamPopularMoviesError`` if the refresh fails.
    ///
    func refresh() async throws(StreamPopularMoviesError)

}
