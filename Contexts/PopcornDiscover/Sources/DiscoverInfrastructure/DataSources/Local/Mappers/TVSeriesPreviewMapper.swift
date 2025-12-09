//
//  TVSeriesPreviewMapper.swift
//  PopcornDiscover
//
//  Created by Adam Young on 05/11/2025.
//

import DiscoverDomain
import Foundation

struct TVSeriesPreviewMapper {

    func map(_ entity: DiscoverTVSeriesPreviewEntity) -> TVSeriesPreview {
        TVSeriesPreview(
            id: entity.tvSeriesID,
            name: entity.name,
            overview: entity.overview,
            firstAirDate: entity.firstAirDate,
            genreIDs: entity.genreIDs,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath
        )
    }

    func compactMap(_ entity: DiscoverTVSeriesPreviewEntity?) -> TVSeriesPreview? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ tvSeries: TVSeriesPreview) -> DiscoverTVSeriesPreviewEntity {
        DiscoverTVSeriesPreviewEntity(
            tvSeriesID: tvSeries.id,
            name: tvSeries.name,
            overview: tvSeries.overview,
            firstAirDate: tvSeries.firstAirDate,
            genreIDs: tvSeries.genreIDs,
            posterPath: tvSeries.posterPath,
            backdropPath: tvSeries.backdropPath
        )
    }

    func map(_ tvSeries: TVSeriesPreview, to entity: DiscoverTVSeriesPreviewEntity) {
        entity.name = tvSeries.name
        entity.overview = tvSeries.overview
        entity.firstAirDate = tvSeries.firstAirDate
        entity.genreIDs = tvSeries.genreIDs
        entity.posterPath = tvSeries.posterPath
        entity.backdropPath = tvSeries.backdropPath
        entity.cachedAt = .now
    }

}
