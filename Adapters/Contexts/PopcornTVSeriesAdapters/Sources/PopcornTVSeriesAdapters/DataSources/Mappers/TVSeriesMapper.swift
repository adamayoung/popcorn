//
//  TVSeriesMapper.swift
//  Popcorn
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
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
