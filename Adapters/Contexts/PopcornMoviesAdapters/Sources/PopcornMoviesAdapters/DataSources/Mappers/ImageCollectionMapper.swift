//
//  ImageCollectionMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct ImageCollectionMapper {

    func map(_ dto: TMDb.ImageCollection) -> MoviesDomain.ImageCollection {
        MoviesDomain.ImageCollection(
            id: dto.id,
            posterPaths: dto.posters.map(\.filePath),
            backdropPaths: dto.backdrops.map(\.filePath),
            logoPaths: dto.logos.map(\.filePath)
        )
    }

}
