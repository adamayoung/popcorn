//
//  TVSeriesPreviewMapper.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation
import TMDb

///
/// Maps TMDb TV series list items to domain ``TVSeriesPreview`` entities.
///
/// This mapper transforms TMDb-specific TV series data into the discover
/// domain's preview model, extracting the essential information needed
/// for displaying TV series cards and lists.
///
struct TVSeriesPreviewMapper {

    ///
    /// Maps a TMDb TV series list item to a TV series preview.
    ///
    /// - Parameter dto: The TMDb TV series list item to map.
    ///
    /// - Returns: A ``TVSeriesPreview`` containing the mapped TV series data.
    ///
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
