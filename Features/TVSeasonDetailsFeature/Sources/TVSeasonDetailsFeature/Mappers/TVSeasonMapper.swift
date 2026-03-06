//
//  TVSeasonMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct TVSeasonMapper {

    func map(_ details: TVSeasonDetails) -> TVSeason {
        TVSeason(
            id: details.id,
            seasonNumber: details.seasonNumber,
            tvSeriesID: details.tvSeriesID,
            name: details.name,
            tvSeriesName: details.tvSeriesName,
            posterURL: details.posterURLSet?.thumbnail,
            overview: details.overview
        )
    }

}
