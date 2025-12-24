//
//  StreamMovieRecommendationsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Defines the contract for streaming movie recommendations.
///
/// This use case provides methods to observe recommended movies for a given movie
/// in real-time, enabling reactive UI updates when the underlying data changes.
///
public protocol StreamMovieRecommendationsUseCase: Sendable {

    ///
    /// Creates a stream that emits recommended movies for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreviewDetails``.
    ///
    func stream(movieID: Movie.ID) async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    ///
    /// Creates a stream that emits recommended movies for a specific movie, with a result limit.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - limit: The maximum number of recommendations to return, or `nil` for no limit.
    /// - Returns: An async throwing stream that emits arrays of ``MoviePreviewDetails``.
    ///
    func stream(
        movieID: Movie.ID,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreviewDetails], Error>

    ///
    /// Loads the next page of recommendations for the stream.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Throws: ``StreamMovieRecommendationsError`` if the next page cannot be loaded.
    ///
    func loadNextPage(movieID: Movie.ID) async throws(StreamMovieRecommendationsError)

}
