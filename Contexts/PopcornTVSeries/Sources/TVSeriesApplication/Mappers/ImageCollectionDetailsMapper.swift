//
//  ImageCollectionDetailsMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct ImageCollectionDetailsMapper {

    func map(_ imageCollection: ImageCollection, imagesConfiguration: ImagesConfiguration)
    -> ImageCollectionDetails {
        let posterURLSets = imageCollection.posterPaths.compactMap {
            imagesConfiguration.posterURLSet(for: $0)
        }
        let backdropURLSets = imageCollection.backdropPaths.compactMap {
            imagesConfiguration.posterURLSet(for: $0)
        }
        let logoURLSets = imageCollection.logoPaths.compactMap {
            imagesConfiguration.logoURLSet(for: $0)
        }

        return ImageCollectionDetails(
            id: imageCollection.id,
            posterURLSets: posterURLSets,
            backdropURLSets: backdropURLSets,
            logoURLSets: logoURLSets
        )
    }

}
