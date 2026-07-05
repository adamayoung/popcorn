//
//  GenreMapper.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresApplication

/// Maps a context ``GenreDetailsExtended`` to the feature's ``Genre`` presentation model.
public struct GenreMapper {

    /// Creates a genre mapper.
    public init() {}

    /// Maps a context ``GenreDetailsExtended`` to a presentation ``Genre``.
    public func map(_ genreDetails: GenreDetailsExtended) -> Genre {
        Genre(
            id: genreDetails.id,
            name: genreDetails.name,
            color: genreDetails.color,
            backdropURL: genreDetails.backdropURLSet?.card
        )
    }

}
