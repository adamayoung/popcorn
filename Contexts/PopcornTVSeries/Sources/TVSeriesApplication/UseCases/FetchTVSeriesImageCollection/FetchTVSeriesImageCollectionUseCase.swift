//
//  FetchTVSeriesImageCollectionUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

///
/// Defines the contract for fetching a TV series' image collection.
///
/// Implementations of this use case retrieve images for a TV series and
/// combine them with image configuration to produce fully-resolved URLs
/// in an ``ImageCollectionDetails`` model.
///
public protocol FetchTVSeriesImageCollectionUseCase: Sendable {

    ///
    /// Fetches the image collection for a TV series.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    /// - Returns: An ``ImageCollectionDetails`` instance containing image URL sets.
    /// - Throws: ``FetchTVSeriesImageCollectionError`` if the images cannot be fetched.
    ///
    func execute(tvSeriesID: TVSeries.ID) async throws(FetchTVSeriesImageCollectionError)
        -> ImageCollectionDetails

}
