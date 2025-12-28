//
//  FetchTrendingTVSeriesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case for fetching trending TV series.
///
/// Implementations retrieve trending TV series data and transform it into
/// presentation-ready models with resolved image URLs.
///
public protocol FetchTrendingTVSeriesUseCase: Sendable {

    ///
    /// Fetches the first page of trending TV series.
    ///
    /// - Returns: An array of trending TV series preview details.
    /// - Throws: ``FetchTrendingTVSeriesError`` if the fetch fails.
    ///
    func execute() async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails]

    ///
    /// Fetches a specific page of trending TV series.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending TV series preview details.
    /// - Throws: ``FetchTrendingTVSeriesError`` if the fetch fails.
    ///
    func execute(page: Int) async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails]

}
