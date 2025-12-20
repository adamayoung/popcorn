//
//  TVSeriesPreviewMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import TMDb

struct TVSeriesPreviewMapper {

    func map(_ dto: TVSeriesListItem) -> TVSeriesPreview {
        TVSeriesPreview(
            id: dto.id,
            name: dto.name,
            overview: dto.overview,
            firstAirDate: dto.firstAirDate ?? Date(),
            genreIDs: dto.genreIDs,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
