//
//  ImageCollectionMapper.swift
//  PopcornMovies
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation
import MoviesDomain

struct ImageCollectionMapper {

    func map(_ entity: MoviesImageCollectionEntity) -> ImageCollection {
        ImageCollection(
            id: entity.movieID,
            posterPaths: entity.posterPaths,
            backdropPaths: entity.backdropPaths,
            logoPaths: entity.logoPaths
        )
    }

    func compactMap(_ entity: MoviesImageCollectionEntity?) -> ImageCollection? {
        guard let entity else {
            return nil
        }

        return map(entity)
    }

    func map(_ imageCollection: ImageCollection) -> MoviesImageCollectionEntity {
        MoviesImageCollectionEntity(
            movieID: imageCollection.id,
            posterPaths: imageCollection.posterPaths,
            backdropPaths: imageCollection.backdropPaths,
            logoPaths: imageCollection.logoPaths
        )
    }

    func map(_ imageCollection: ImageCollection, to entity: MoviesImageCollectionEntity) {
        entity.posterPaths = imageCollection.posterPaths
        entity.backdropPaths = imageCollection.backdropPaths
        entity.logoPaths = imageCollection.logoPaths
        entity.cachedAt = .now
    }

}
