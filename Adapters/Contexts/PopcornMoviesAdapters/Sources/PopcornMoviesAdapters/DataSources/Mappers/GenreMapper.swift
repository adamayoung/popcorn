//
//  GenreMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct GenreMapper {

    func map(_ dto: TMDb.Genre) -> MoviesDomain.Genre {
        MoviesDomain.Genre(id: dto.id, name: dto.name)
    }

}
