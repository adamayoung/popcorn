//
//  TVSeriesPreviewMapper.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb
import TrendingDomain

///
/// A mapper that converts TMDb TV series list items to trending domain TV series previews.
///
struct TVSeriesPreviewMapper {

    ///
    /// Maps a TMDb TV series list item to a trending domain TV series preview.
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
