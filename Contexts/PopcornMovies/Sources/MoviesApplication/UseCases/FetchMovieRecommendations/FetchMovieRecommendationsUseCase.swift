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

}
