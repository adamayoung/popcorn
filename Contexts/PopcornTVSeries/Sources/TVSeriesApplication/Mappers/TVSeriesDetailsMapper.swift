//
//  TVSeriesDetailsMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVSeriesDetailsMapper {

    func map(
        _ tvSeries: TVSeries, imageCollection: ImageCollection,
        imagesConfiguration: ImagesConfiguration
    ) -> TVSeriesDetails {
        let posterURLSet = imagesConfiguration.posterURLSet(for: tvSeries.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: tvSeries.backdropPath)
        let logoURLSet = imagesConfiguration.logoURLSet(for: imageCollection.logoPaths.first)

        return TVSeriesDetails(
            id: tvSeries.id,
            name: tvSeries.name,
            overview: tvSeries.overview,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet
        )
    }

}
