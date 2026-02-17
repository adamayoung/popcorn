//
//  TVSeriesMapper.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import TVSeriesApplication

struct TVSeriesMapper {

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
