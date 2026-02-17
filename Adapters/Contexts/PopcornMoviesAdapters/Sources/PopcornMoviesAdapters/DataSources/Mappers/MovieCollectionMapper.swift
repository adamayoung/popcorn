//
//  MovieCollectionMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct MovieCollectionMapper {

    func map(_ dto: TMDb.BelongsToCollection) -> MoviesDomain.MovieCollection {
        MoviesDomain.MovieCollection(
            id: dto.id,
            name: dto.name,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
