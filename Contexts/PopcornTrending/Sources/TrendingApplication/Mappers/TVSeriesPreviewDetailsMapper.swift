//
//  TVSeriesPreviewDetailsMapper.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

struct TVSeriesPreviewDetailsMapper {

    func map(_ tvSeriesPreview: TVSeriesPreview, imagesConfiguration: ImagesConfiguration)
    -> TVSeriesPreviewDetails {
        let posterURLSet = imagesConfiguration.posterURLSet(for: tvSeriesPreview.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: tvSeriesPreview.backdropPath)

        return TVSeriesPreviewDetails(
            id: tvSeriesPreview.id,
            name: tvSeriesPreview.name,
            overview: tvSeriesPreview.overview,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )
    }

}
