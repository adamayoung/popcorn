//
//  MovieListItemMapper.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 29/05/2025.
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
