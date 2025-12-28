//
//  FetchPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case that fetches popular movies.
///
/// This protocol defines the contract for retrieving a list of currently popular movies,
/// with support for pagination to load additional pages of results.
///
public protocol FetchPopularMoviesUseCase: Sendable {

    ///
    /// Fetches the first page of popular movies.
    ///
    /// - Returns: An array of ``MoviePreviewDetails`` representing popular movies.
    /// - Throws: ``FetchPopularMoviesError`` if the movies cannot be fetched.
    ///
    func execute() async throws(FetchPopularMoviesError) -> [MoviePreviewDetails]

    ///
    /// Fetches a specific page of popular movies.
    ///
    /// - Parameter page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreviewDetails`` representing popular movies.
    /// - Throws: ``FetchPopularMoviesError`` if the movies cannot be fetched.
    ///
    func execute(page: Int) async throws(FetchPopularMoviesError) -> [MoviePreviewDetails]

}
