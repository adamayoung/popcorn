//
//  TVSeriesPreviewDetailsMapper.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

struct TVSeriesPreviewDetailsMapper {

    func map(
        _ tvSeriesPreview: TVSeriesPreview,
        genresLookup: [Genre.ID: Genre],
        logoURLSet: ImageURLSet?,
        imagesConfiguration: ImagesConfiguration,
        themeColor: ThemeColor? = nil
    ) -> TVSeriesPreviewDetails {
        let genres = tvSeriesPreview.genreIDs.compactMap { genresLookup[$0] }
        let posterURLSet = imagesConfiguration.posterURLSet(for: tvSeriesPreview.posterPath)
        let backdropURLSet = imagesConfiguration.backdropURLSet(for: tvSeriesPreview.backdropPath)

        return TVSeriesPreviewDetails(
            id: tvSeriesPreview.id,
            name: tvSeriesPreview.name,
            overview: tvSeriesPreview.overview,
            firstAirDate: tvSeriesPreview.firstAirDate,
            genres: genres,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet,
            themeColor: themeColor
        )
    }

}
