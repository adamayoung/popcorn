//
//  TVSeriesMapper.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct TVSeriesMapper {

    func map(_ tvSeriesDetails: TVSeriesDetails) -> TVSeries {
        TVSeries(
            id: tvSeriesDetails.id,
            name: tvSeriesDetails.name,
            tagline: tvSeriesDetails.tagline
        )
    }

}
