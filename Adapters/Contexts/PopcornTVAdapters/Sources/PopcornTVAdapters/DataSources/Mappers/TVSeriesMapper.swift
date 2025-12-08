//
//  TVSeriesMapper.swift
//  PopcornTVAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import Foundation
import TMDb
import TVDomain

struct TVSeriesMapper {

    func map(_ dto: TMDb.TVSeries) -> TVDomain.TVSeries {
        TVDomain.TVSeries(
            id: dto.id,
            name: dto.name,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
