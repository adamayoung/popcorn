//
//  GenreMapper.swift
//  PopcornGenresAdapters
//
//  Created by Adam Young on 09/12/2025.
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
