//
//  ImageCollectionMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

///
/// Maps TMDb image collection data transfer objects to domain image collection entities.
///
struct ImageCollectionMapper {

    ///
    /// Maps a TMDb image collection to a domain image collection entity.
    ///
    /// - Parameter dto: The TMDb image collection data transfer object.
    ///
    /// - Returns: A domain image collection entity containing poster, backdrop, and logo paths.
    ///
    func map(_ dto: TMDb.ImageCollection) -> MoviesDomain.ImageCollection {
        MoviesDomain.ImageCollection(
            id: dto.id,
            posterPaths: dto.posters.map(\.filePath),
            backdropPaths: dto.backdrops.map(\.filePath),
            logoPaths: dto.logos.map(\.filePath)
        )
    }

}
