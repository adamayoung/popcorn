//
//  MoviePreviewMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import TMDb

///
/// Maps TMDb movie list items to domain ``MoviePreview`` entities.
///
/// This mapper transforms TMDb-specific movie data into the discover
/// domain's preview model, extracting the essential information needed
/// for displaying movie cards and lists.
///
struct MoviePreviewMapper {

    ///
    /// Maps a TMDb movie list item to a movie preview.
    ///
    /// - Parameter dto: The TMDb movie list item to map.
    ///
    /// - Returns: A ``MoviePreview`` containing the mapped movie data.
    ///
    func map(_ dto: MovieListItem) -> MoviePreview {
        MoviePreview(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            releaseDate: dto.releaseDate ?? Date(),
            genreIDs: dto.genreIDs,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
