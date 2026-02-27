//
//  TVSeriesImageCollectionEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct TVSeriesImageCollectionEntityMapper {

    func map(_ entity: TVSeriesImageCollectionEntity) -> ImageCollection {
        ImageCollection(
            id: entity.tvSeriesID,
            posterPaths: entity.posterPaths,
            backdropPaths: entity.backdropPaths,
            logoPaths: entity.logoPaths
        )
    }

    func map(_ imageCollection: ImageCollection) -> TVSeriesImageCollectionEntity {
        TVSeriesImageCollectionEntity(
            tvSeriesID: imageCollection.id,
            posterPaths: imageCollection.posterPaths,
            backdropPaths: imageCollection.backdropPaths,
            logoPaths: imageCollection.logoPaths
        )
    }

    func map(
        _ imageCollection: ImageCollection,
        to entity: TVSeriesImageCollectionEntity
    ) {
        entity.posterPaths = imageCollection.posterPaths
        entity.backdropPaths = imageCollection.backdropPaths
        entity.logoPaths = imageCollection.logoPaths
        entity.cachedAt = .now
    }

}
