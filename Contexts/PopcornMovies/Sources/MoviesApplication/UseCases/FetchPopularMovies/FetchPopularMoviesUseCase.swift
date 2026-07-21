//
//  FetchPopularMoviesUseCase.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchPopularMoviesUseCase: Sendable {

    ///
    /// Fetches the first page of popular movies.
    ///
    /// - Returns: A ``MoviePreviewDetailsPage`` of popular movies with pagination metadata.
    /// - Throws: ``FetchPopularMoviesError`` if the movies cannot be fetched.
    ///
    func execute() async throws(FetchPopularMoviesError) -> MoviePreviewDetailsPage

    ///
    /// Fetches a page of popular movies.
    ///
    /// - Parameter page: The page number to fetch (1-indexed).
    /// - Returns: A ``MoviePreviewDetailsPage`` of popular movies with pagination metadata.
    /// - Throws: ``FetchPopularMoviesError`` if the movies cannot be fetched.
    ///
    func execute(page: Int) async throws(FetchPopularMoviesError) -> MoviePreviewDetailsPage

}
