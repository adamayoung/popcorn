//
//  TVSeriesPreviewMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import TMDb

struct TVSeriesPreviewMapper {

    func map(_ dto: TVSeriesListItem) -> TVSeriesPreview {
        TVSeriesPreview(
            id: dto.id,
            name: dto.name,
            overview: dto.overview,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
