//
//  TVSeriesDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVSeriesDetailsMapper {

    private let seasonMapper = TVSeasonSummaryMapper()

    func map(
        _ tvSeries: TVSeries, imageCollection: ImageCollection,
        imagesConfiguration: ImagesConfiguration
    ) -> TVSeriesDetails {
        let posterURLSet = imagesConfiguration.posterURLSet(for: tvSeries.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: tvSeries.backdropPath)
        let logoURLSet = imagesConfiguration.logoURLSet(for: imageCollection.logoPaths.first)
        let seasons = tvSeries.seasons.map { seasonMapper.map($0, imagesConfiguration: imagesConfiguration) }

        return TVSeriesDetails(
            id: tvSeries.id,
            name: tvSeries.name,
            tagline: tvSeries.tagline,
            overview: tvSeries.overview,
            numberOfSeasons: tvSeries.numberOfSeasons,
            firstAirDate: tvSeries.firstAirDate,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet,
            seasons: seasons
        )
    }

}
