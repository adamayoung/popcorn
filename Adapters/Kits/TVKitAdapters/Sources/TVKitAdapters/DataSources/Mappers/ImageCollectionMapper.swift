//
//  ImageCollectionMapper.swift
//  TVKit
//
//  Created by Adam Young on 21/11/2025.
//

import Foundation
import TMDb
import TVDomain

struct ImageCollectionMapper {

    func map(_ tmdbImageCollection: TMDb.ImageCollection) -> TVDomain.ImageCollection {
        TVDomain.ImageCollection(
            id: tmdbImageCollection.id,
            posterPaths: tmdbImageCollection.posters.map(\.filePath),
            backdropPaths: tmdbImageCollection.backdrops.map(\.filePath),
            logoPaths: tmdbImageCollection.logos.map(\.filePath)
        )
    }

}
