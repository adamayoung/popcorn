//
//  TVSeriesMapper.swift
//  PopcornTVSeriesAdapters
//
//  Created by Adam Young on 29/05/2025.
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
