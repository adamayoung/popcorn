//
//  MoviePreviewMapper.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb
import TrendingDomain

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
