//
//  MoviePreviewMapper.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain
import TMDb

struct MoviePreviewMapper {

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
