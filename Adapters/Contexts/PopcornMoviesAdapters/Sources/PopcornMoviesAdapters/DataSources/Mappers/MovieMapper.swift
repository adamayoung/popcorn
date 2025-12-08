//
//  MovieMapper.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import Foundation
import MoviesDomain
import TMDb

struct MovieMapper {

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
