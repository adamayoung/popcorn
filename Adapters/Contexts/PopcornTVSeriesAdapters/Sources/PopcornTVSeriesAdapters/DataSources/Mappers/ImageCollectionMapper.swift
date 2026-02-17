//
//  ImageCollectionMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct ImageCollectionMapper {

    func map(_ tmdbImageCollection: TMDb.ImageCollection) -> TVSeriesDomain.ImageCollection {
        TVSeriesDomain.ImageCollection(
            id: tmdbImageCollection.id,
            posterPaths: tmdbImageCollection.posters.map(\.filePath),
            backdropPaths: tmdbImageCollection.backdrops.map(\.filePath),
            logoPaths: tmdbImageCollection.logos.map(\.filePath)
        )
    }

}
