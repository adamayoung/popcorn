//
//  TVSeriesMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct TVSeriesMapper {

    func map(_ dto: TMDb.TVSeries) -> TVSeriesDomain.TVSeries {
        TVSeriesDomain.TVSeries(
            id: dto.id,
            name: dto.name,
            tagline: dto.tagline,
            overview: dto.overview ?? "",
            numberOfSeasons: dto.numberOfSeasons ?? 0,
            firstAirDate: dto.firstAirDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
