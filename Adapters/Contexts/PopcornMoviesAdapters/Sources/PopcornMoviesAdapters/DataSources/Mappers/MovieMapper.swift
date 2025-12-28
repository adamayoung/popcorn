//
//  MovieMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

///
/// Maps TMDb movie data transfer objects to domain movie entities.
///
struct MovieMapper {

    ///
    /// Maps a TMDb movie to a domain movie entity.
    ///
    /// - Parameter dto: The TMDb movie data transfer object.
    ///
    /// - Returns: A domain movie entity.
    ///
    func map(_ dto: TMDb.Movie) -> MoviesDomain.Movie {
        MoviesDomain.Movie(
            id: dto.id,
            title: dto.title,
            overview: dto.overview ?? "",
            releaseDate: dto.releaseDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
