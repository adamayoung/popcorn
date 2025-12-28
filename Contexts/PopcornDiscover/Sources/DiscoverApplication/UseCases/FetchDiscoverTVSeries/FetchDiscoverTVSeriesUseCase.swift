//
//  FetchDiscoverTVSeriesUseCase.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

///
/// Defines the contract for fetching discoverable TV series with enriched details.
///
/// This use case retrieves TV series previews and enriches them with genre names,
/// fully-resolved image URLs, and logo images for display in discovery interfaces.
///
public protocol FetchDiscoverTVSeriesUseCase: Sendable {

    ///
    /// Fetches the first page of TV series without any filters.
    ///
    /// - Returns: An array of ``TVSeriesPreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverTVSeriesError`` if the TV series cannot be fetched.
    ///
    func execute() async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

    ///
    /// Fetches the first page of TV series matching the specified filter.
    ///
    /// - Parameter filter: The filter criteria to apply.
    /// - Returns: An array of ``TVSeriesPreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverTVSeriesError`` if the TV series cannot be fetched.
    ///
    func execute(
        filter: TVSeriesFilter
    ) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

    ///
    /// Fetches a specific page of TV series without any filters.
    ///
    /// - Parameter page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``TVSeriesPreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverTVSeriesError`` if the TV series cannot be fetched.
    ///
    func execute(page: Int) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

    ///
    /// Fetches a specific page of TV series matching the specified filter.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria to apply. Pass `nil` for no filtering.
    ///   - page: The page number to fetch (1-indexed).
    /// - Returns: An array of ``TVSeriesPreviewDetails`` with enriched data.
    /// - Throws: ``FetchDiscoverTVSeriesError`` if the TV series cannot be fetched.
    ///
    func execute(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(FetchDiscoverTVSeriesError) -> [TVSeriesPreviewDetails]

}
