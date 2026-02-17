//
//  GenreMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
import Foundation
import GenresDomain

struct GenreMapper {

    func map(_ genre: GenresDomain.Genre) -> DiscoverDomain.Genre {
        Genre(
            id: genre.id,
            name: genre.name
        )
    }

}
