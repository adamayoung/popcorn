//
//  TVSeriesMapper.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import TVSeriesApplication

///
/// A mapper that transforms TV series models between application and domain layers.
///
/// Converts ``TVSeriesDetails`` instances from the TV series application layer to
/// ``TVSeries`` instances for use in the intelligence domain.
///
struct TVSeriesMapper {

    ///
    /// Maps TV series details to a TV series for the intelligence domain.
    ///
    /// - Parameter tvSeriesDetails: The TV series details from the TV series application layer.
    /// - Returns: A TV series suitable for the intelligence domain.
    ///
    func map(_ tvSeriesDetails: TVSeriesDetails) -> IntelligenceDomain.TVSeries {
        IntelligenceDomain.TVSeries(
            id: tvSeriesDetails.id,
            name: tvSeriesDetails.name,
            tagline: tvSeriesDetails.tagline,
            overview: tvSeriesDetails.overview,
            numberOfSeasons: tvSeriesDetails.numberOfSeasons,
            posterPath: tvSeriesDetails.posterURLSet?.path,
            backdropPath: tvSeriesDetails.backdropURLSet?.path
        )
    }

}
