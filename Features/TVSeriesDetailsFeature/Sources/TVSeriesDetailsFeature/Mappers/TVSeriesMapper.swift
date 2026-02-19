//
//  TVSeriesMapper.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct TVSeriesMapper {

    private let tvSeasonPreviewMapper = TVSeasonPreviewMapper()

    func map(_ tvSeriesDetails: TVSeriesDetails) -> TVSeries {
        TVSeries(
            id: tvSeriesDetails.id,
            name: tvSeriesDetails.name,
            overview: tvSeriesDetails.overview,
            posterURL: tvSeriesDetails.posterURLSet?.detail,
            backdropURL: tvSeriesDetails.backdropURLSet?.full,
            logoURL: tvSeriesDetails.logoURLSet?.detail,
            seasons: tvSeriesDetails.seasons.map(tvSeasonPreviewMapper.map)
        )
    }

}
