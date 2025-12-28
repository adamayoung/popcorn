//
//  MoviePreviewMapper.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import TMDb

///
/// A mapper that converts TMDb movie list items to domain movie previews.
///
struct MoviePreviewMapper {

    ///
    /// Maps a TMDb movie list item to a domain movie preview.
    ///
    /// - Parameter dto: The TMDb movie list item to map.
    ///
    /// - Returns: A ``MoviePreview`` populated with the movie data.
    ///
    func map(_ dto: MovieListItem) -> MoviePreview {
        MoviePreview(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
