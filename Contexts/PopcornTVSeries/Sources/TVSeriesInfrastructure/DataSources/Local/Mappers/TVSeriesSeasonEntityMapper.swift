//
//  TVSeriesSeasonEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct TVSeriesSeasonEntityMapper {

    func map(_ entity: TVSeriesSeasonEntity) -> TVSeason {
        TVSeason(
            id: entity.seasonID,
            name: entity.name,
            seasonNumber: entity.seasonNumber,
            posterPath: entity.posterPath
        )
    }

    func map(_ season: TVSeason) -> TVSeriesSeasonEntity {
        TVSeriesSeasonEntity(
            seasonID: season.id,
            name: season.name,
            seasonNumber: season.seasonNumber,
            posterPath: season.posterPath
        )
    }

    func map(_ season: TVSeason, to entity: TVSeriesSeasonEntity) {
        entity.name = season.name
        entity.seasonNumber = season.seasonNumber
        entity.posterPath = season.posterPath
    }

}
