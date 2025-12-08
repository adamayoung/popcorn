//
//  ImageCollectionMapper.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 21/11/2025.
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
