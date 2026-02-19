//
//  TVSeasonMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct TVSeasonMapper {

    func map(_ dto: TMDb.TVSeason) -> TVSeriesDomain.TVSeason {
        TVSeriesDomain.TVSeason(
            id: dto.id,
            name: dto.name,
            seasonNumber: dto.seasonNumber,
            posterPath: dto.posterPath
        )
    }

}
