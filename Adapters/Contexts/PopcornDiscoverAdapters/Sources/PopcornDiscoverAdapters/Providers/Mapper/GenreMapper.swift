//
//  GenreMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
