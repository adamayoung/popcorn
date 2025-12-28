//
//  FetchTrendingMoviesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case for fetching trending movies.
///
/// Implementations retrieve trending movie data and transform it into
/// presentation-ready models with resolved image URLs.
///
public protocol FetchTrendingMoviesUseCase: Sendable {

    ///
    /// Fetches the first page of trending movies.
    ///
    /// - Returns: An array of trending movie preview details.
    /// - Throws: ``FetchTrendingMoviesError`` if the fetch fails.
    ///
    func execute() async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

    ///
    /// Fetches a specific page of trending movies.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending movie preview details.
    /// - Throws: ``FetchTrendingMoviesError`` if the fetch fails.
    ///
    func execute(page: Int) async throws(FetchTrendingMoviesError) -> [MoviePreviewDetails]

}
