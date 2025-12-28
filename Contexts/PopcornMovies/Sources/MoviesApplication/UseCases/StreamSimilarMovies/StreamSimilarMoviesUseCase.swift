//
//  StreamSimilarMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// A use case that streams real-time updates of similar movies.
///
/// This protocol defines the contract for observing changes to similar movies over time.
/// The stream supports pagination and optional result limiting for efficient data loading.
///
public protocol StreamSimilarMoviesUseCase: Sendable {

    ///
    /// Creates a stream that emits similar movies for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreviewDetails``.
    ///
    func stream(movieID: Movie.ID) async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    ///
    /// Creates a stream that emits similar movies for a specific movie with a result limit.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - limit: The maximum number of movies to return, or `nil` for no limit.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreviewDetails``.
    ///
    func stream(
        movieID: Movie.ID,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    ///
    /// Loads the next page of similar movies into the stream.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Throws: ``StreamSimilarMoviesError`` if the next page cannot be loaded.
    ///
    func loadNextPage(movieID: Movie.ID) async throws(StreamSimilarMoviesError)

}
