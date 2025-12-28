//
//  MoviePreviewMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

///
/// Maps TMDb movie list item data transfer objects to domain movie preview entities.
///
struct MoviePreviewMapper {

    ///
    /// Maps a TMDb movie list item to a domain movie preview entity.
    ///
    /// - Parameter dto: The TMDb movie list item data transfer object.
    ///
    /// - Returns: A domain movie preview entity.
    ///
    func map(_ dto: MovieListItem) -> MoviePreview {
        MoviePreview(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            releaseDate: dto.releaseDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
