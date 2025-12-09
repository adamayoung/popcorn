//
//  GenreMapper.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 09/12/2025.
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
