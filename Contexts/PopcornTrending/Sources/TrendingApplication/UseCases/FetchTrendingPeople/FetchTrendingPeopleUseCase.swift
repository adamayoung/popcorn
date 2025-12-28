//
//  FetchTrendingPeopleUseCase.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A use case for fetching trending people.
///
/// Implementations retrieve trending person data and transform it into
/// presentation-ready models with resolved image URLs.
///
public protocol FetchTrendingPeopleUseCase: Sendable {

    ///
    /// Fetches the first page of trending people.
    ///
    /// - Returns: An array of trending person preview details.
    /// - Throws: ``FetchTrendingPeopleError`` if the fetch fails.
    ///
    func execute() async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails]

    ///
    /// Fetches a specific page of trending people.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: An array of trending person preview details.
    /// - Throws: ``FetchTrendingPeopleError`` if the fetch fails.
    ///
    func execute(page: Int) async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails]

}
