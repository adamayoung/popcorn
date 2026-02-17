//
//  GenreMapper.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import MoviesDomain

struct GenreMapper {

    func map(_ genre: MoviesDomain.Genre) -> Genre {
        Genre(id: genre.id, name: genre.name)
    }

}
