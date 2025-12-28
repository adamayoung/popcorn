//
//  TVSeriesPreviewMapper.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
import TMDb

///
/// A mapper that converts TMDb TV series list items to domain TV series previews.
///
struct TVSeriesPreviewMapper {

    ///
    /// Maps a TMDb TV series list item to a domain TV series preview.
    ///
    /// - Parameter dto: The TMDb TV series list item to map.
    ///
    /// - Returns: A ``TVSeriesPreview`` populated with the TV series data.
    ///
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
