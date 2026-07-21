//
//  FetchMovieRecommendationsUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

///
/// Defines the contract for fetching movie recommendations.
///
/// This use case provides methods to fetch recommended movies for a given movie,
/// based on user ratings and viewing preferences. Unlike similar movies (which are
/// based on keywords and genres), recommendations are personalized based on user behavior.
///
public protocol FetchMovieRecommendationsUseCase: Sendable {

    ///
    /// Fetches the first page of recommended movies for a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: An array of ``MoviePreviewDetails`` instances representing recommended movies.
    /// - Throws: ``FetchMovieRecommendationsError`` if the recommendations cannot be fetched.
    ///
    func execute(
        movieID: Movie.ID
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails]

    ///
    /// Fetches a specific page of recommended movies for a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreviewDetails`` instances representing recommended movies.
    /// - Throws: ``FetchMovieRecommendationsError`` if the recommendations cannot be fetched.
    ///
    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails]

    ///
    /// Fetches a page of recommended movies, capped to a maximum number of results.
    ///
    /// Implementations should apply the limit **before** any per-movie enrichment
    /// (image collections, theme colours), so discarded movies never incur that cost.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    ///   - limit: The maximum number of movies to return, or `nil` for no limit.
    /// - Returns: An array of ``MoviePreviewDetails`` instances representing recommended movies.
    /// - Throws: ``FetchMovieRecommendationsError`` if the recommendations cannot be fetched.
    ///
    func execute(
        movieID: Movie.ID,
        page: Int,
        limit: Int?
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails]

}

public extension FetchMovieRecommendationsUseCase {

    ///
    /// Fetches a page of recommended movies, capped to a maximum number of results.
    ///
    /// This default forwards to ``execute(movieID:page:)`` and trims the result, so
    /// conformers that only implement the unlimited variants stay source-compatible.
    /// Conformers that can enrich lazily should override this to apply the limit
    /// before enrichment.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    ///   - limit: The maximum number of movies to return, or `nil` for no limit.
    /// - Returns: An array of ``MoviePreviewDetails`` instances representing recommended movies.
    /// - Throws: ``FetchMovieRecommendationsError`` if the recommendations cannot be fetched.
    ///
    func execute(
        movieID: Movie.ID,
        page: Int,
        limit: Int?
    ) async throws(FetchMovieRecommendationsError) -> [MoviePreviewDetails] {
        let results = try await execute(movieID: movieID, page: page)
        guard let limit else {
            return results
        }

        return Array(results.prefix(limit))
    }

}
