//
//  ImageCollectionMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

///
/// A mapper that converts TMDb image collections to the domain model.
///
struct ImageCollectionMapper {

    ///
    /// Maps a TMDb image collection to a TV series domain image collection.
    ///
    /// - Parameter tmdbImageCollection: The TMDb image collection to map.
    ///
    /// - Returns: A ``TVSeriesDomain.ImageCollection`` containing poster, backdrop, and logo paths.
    ///
    func map(_ tmdbImageCollection: TMDb.ImageCollection) -> TVSeriesDomain.ImageCollection {
        TVSeriesDomain.ImageCollection(
            id: tmdbImageCollection.id,
            posterPaths: tmdbImageCollection.posters.map(\.filePath),
            backdropPaths: tmdbImageCollection.backdrops.map(\.filePath),
            logoPaths: tmdbImageCollection.logos.map(\.filePath)
        )
    }

}
