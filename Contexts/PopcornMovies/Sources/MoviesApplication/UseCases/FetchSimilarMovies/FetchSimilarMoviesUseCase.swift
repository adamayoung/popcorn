//
//  FetchSimilarMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// A use case that fetches movies similar to a given movie.
///
/// This protocol defines the contract for retrieving movies that share similar
/// characteristics (genres, keywords, etc.) with a reference movie.
///
public protocol FetchSimilarMoviesUseCase: Sendable {

    ///
    /// Fetches the first page of movies similar to a specific movie.
    ///
    /// - Parameter movieID: The unique identifier of the reference movie.
    /// - Returns: An array of ``MoviePreviewDetails`` representing similar movies.
    /// - Throws: ``FetchSimilarMoviesError`` if the movies cannot be fetched.
    ///
    func execute(
        movieID: Movie.ID
    ) async throws(FetchSimilarMoviesError) -> [MoviePreviewDetails]

    ///
    /// Fetches a specific page of movies similar to a specific movie.
    ///
    /// - Parameters:
    ///   - movieID: The unique identifier of the reference movie.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreviewDetails`` representing similar movies.
    /// - Throws: ``FetchSimilarMoviesError`` if the movies cannot be fetched.
    ///
    func execute(
        movieID: Movie.ID,
        page: Int
    ) async throws(FetchSimilarMoviesError) -> [MoviePreviewDetails]

}
