//
//  TVSeriesMapper.swift
//  TVSeriesDetailsFeature
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
            overview: tvSeriesDetails.overview,
            posterURL: tvSeriesDetails.posterURLSet?.detail,
            backdropURL: tvSeriesDetails.backdropURLSet?.full,
            logoURL: tvSeriesDetails.logoURLSet?.detail,
            seasons: tvSeriesDetails.seasons.map {
                TVSeasonPreview(id: $0.id, seasonNumber: $0.seasonNumber, name: $0.name, posterURL: $0.posterURL)
            }
        )
    }

}
