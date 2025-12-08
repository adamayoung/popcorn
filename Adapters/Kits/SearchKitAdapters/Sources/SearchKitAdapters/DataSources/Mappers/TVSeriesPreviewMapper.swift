//
//  TVSeriesPreviewMapper.swift
//  SearchKitAdapters
//
//  Created by Adam Young on 09/06/2025.
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
