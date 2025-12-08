//
//  MovieListItemMapper.swift
//  SearchKitAdapters
//
//  Created by Adam Young on 29/05/2025.
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
