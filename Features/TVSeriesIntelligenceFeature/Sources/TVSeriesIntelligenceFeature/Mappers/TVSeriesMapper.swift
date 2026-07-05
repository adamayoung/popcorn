//
//  TVSeriesMapper.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// Maps a context ``TVSeriesDetails`` to the feature's ``TVSeries`` presentation model.
public struct TVSeriesMapper {

    /// Creates a TV series mapper.
    public init() {}

    /// Maps a context ``TVSeriesDetails`` to a presentation ``TVSeries``.
    public func map(_ tvSeriesDetails: TVSeriesDetails) -> TVSeries {
        TVSeries(
            id: tvSeriesDetails.id,
            name: tvSeriesDetails.name,
            tagline: tvSeriesDetails.tagline
        )
    }

}
