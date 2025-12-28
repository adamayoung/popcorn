//
//  GenreMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import GenresDomain

///
/// A mapper that transforms genre models between domain layers.
///
/// Converts ``GenresDomain.Genre`` instances to ``DiscoverDomain.Genre``
/// instances for use in the discover context.
///
struct GenreMapper {

    ///
    /// Maps a genre from the genres domain to the discover domain.
    ///
    /// - Parameter genre: The genre from the genres domain.
    /// - Returns: A genre suitable for the discover domain.
    ///
    func map(_ genre: GenresDomain.Genre) -> DiscoverDomain.Genre {
        Genre(
            id: genre.id,
            name: genre.name
        )
    }

}
