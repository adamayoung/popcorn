//
//  TVSeriesToolMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain

struct TVSeriesToolMapper {

    func map(_ tvSeries: TVSeries) -> TVSeriesTool.TVSeries {
        TVSeriesTool.TVSeries(
            id: tvSeries.id,
            name: tvSeries.name,
            tagline: tvSeries.tagline,
            overview: tvSeries.overview,
            numberOfSeasons: tvSeries.numberOfSeasons
        )
    }

}
