//
//  MoviePreviewMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct MoviePreviewMapper {

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
