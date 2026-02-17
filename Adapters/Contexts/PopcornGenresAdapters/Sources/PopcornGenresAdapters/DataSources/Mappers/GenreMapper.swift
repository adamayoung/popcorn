//
//  GenreMapper.swift
//  PopcornGenresAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain
import TMDb

struct GenreMapper {

    func map(_ tmdbGenre: TMDb.Genre) -> GenresDomain.Genre {
        Genre(
            id: tmdbGenre.id,
            name: tmdbGenre.name
        )
    }

}
