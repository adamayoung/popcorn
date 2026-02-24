//
//  GenreMapper.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import TVSeriesDomain

struct GenreMapper {

    func map(_ genre: TVSeriesDomain.Genre) -> Genre {
        Genre(id: genre.id, name: genre.name)
    }

}
