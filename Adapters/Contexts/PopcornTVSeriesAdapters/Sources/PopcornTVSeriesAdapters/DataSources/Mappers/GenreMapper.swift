//
//  GenreMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import TMDb
import TVSeriesDomain

struct GenreMapper {

    func map(_ dto: TMDb.Genre) -> TVSeriesDomain.Genre {
        TVSeriesDomain.Genre(id: dto.id, name: dto.name)
    }

}
