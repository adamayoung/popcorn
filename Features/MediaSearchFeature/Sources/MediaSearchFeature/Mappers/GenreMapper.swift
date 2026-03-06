//
//  GenreMapper.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresApplication

struct GenreMapper {

    func map(_ genreDetails: GenreDetailsExtended) -> Genre {
        Genre(
            id: genreDetails.id,
            name: genreDetails.name,
            color: genreDetails.color,
            backdropURL: genreDetails.backdropURLSet?.card
        )
    }

}
