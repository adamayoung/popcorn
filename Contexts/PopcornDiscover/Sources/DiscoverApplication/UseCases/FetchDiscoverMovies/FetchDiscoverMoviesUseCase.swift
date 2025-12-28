//
//  FetchDiscoverMoviesUseCase.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

///
/// Defines the contract for fetching discoverable movies with enriched details.
///
/// This use case retrieves movie previews and enriches them with genre names,
/// fully-resolved image URLs, and logo images for display in discovery interfaces.
///
public protocol FetchDiscoverMoviesUseCase: Sendable {

    ///
    /// Fetches the first page of movies without any filters.
    ///
    /// - Returns: An array of ``MoviePreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverMoviesError`` if the movies cannot be fetched.
    ///
    func execute() async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails]

    ///
    /// Fetches the first page of movies matching the specified filter.
    ///
    /// - Parameter filter: The filter criteria to apply.
    /// - Returns: An array of ``MoviePreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverMoviesError`` if the movies cannot be fetched.
    ///
    func execute(filter: MovieFilter) async throws(FetchDiscoverMoviesError)
        -> [MoviePreviewDetails]

    ///
    /// Fetches a specific page of movies without any filters.
    ///
    /// - Parameter page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverMoviesError`` if the movies cannot be fetched.
    ///
    func execute(page: Int) async throws(FetchDiscoverMoviesError) -> [MoviePreviewDetails]

    ///
    /// Fetches a specific page of movies matching the specified filter.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply. Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``MoviePreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverMoviesError`` if the movies cannot be fetched.
    ///
    func execute(filter: MovieFilter?, page: Int) async throws(FetchDiscoverMoviesError)
        -> [MoviePreviewDetails]

}
