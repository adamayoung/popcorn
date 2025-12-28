//
//  FetchTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

///
/// Defines the contract for fetching detailed TV series information.
///
/// Implementations of this use case retrieve a TV series by its identifier
/// and combine it with image configuration to produce a complete
/// ``TVSeriesDetails`` model ready for presentation.
///
public protocol FetchTVSeriesDetailsUseCase: Sendable {

    ///
    /// Fetches detailed information for a TV series.
    ///
    /// - Parameter id: The unique identifier of the TV series.
    /// - Returns: A ``TVSeriesDetails`` instance containing the series' information and image URLs.
    /// - Throws: ``FetchTVSeriesDetailsError`` if the series cannot be fetched.
    ///
    func execute(id: TVSeries.ID) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails

}
