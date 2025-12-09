//
//  MovieListItemMapper.swift
//  PopcornDiscoverAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import DiscoverDomain
import Foundation
import TMDb

struct MoviePreviewMapper {

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
