//
//  TVSeasonSummaryMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVSeasonSummaryMapper {

    func map(_ season: TVSeason, imagesConfiguration: ImagesConfiguration) -> TVSeasonSummary {
        TVSeasonSummary(
            id: season.id,
            name: season.name,
            seasonNumber: season.seasonNumber,
            posterURL: imagesConfiguration.posterURLSet(for: season.posterPath)?.detail
        )
    }

}
