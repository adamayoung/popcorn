//
//  GenreMapper.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain
import TMDb

///
/// Maps TMDb genre objects to domain ``Genre`` entities.
///
/// This mapper transforms TMDb-specific genre data into the genres
/// domain's model, enabling consistent genre representation across
/// the application.
///
struct GenreMapper {

    ///
    /// Maps a TMDb genre to a domain genre.
    ///
    /// - Parameter tmdbGenre: The TMDb genre to map.
    ///
    /// - Returns: A ``Genre`` containing the mapped genre data.
    ///
    func map(_ tmdbGenre: TMDb.Genre) -> GenresDomain.Genre {
        Genre(
            id: tmdbGenre.id,
            name: tmdbGenre.name
        )
    }

}
