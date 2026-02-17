//
//  TVSeriesPreviewMapper.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingApplication

struct TVSeriesPreviewMapper {

    func map(_ tvSeriesPreviewDetails: TVSeriesPreviewDetails) -> TVSeriesPreview {
        TVSeriesPreview(
            id: tvSeriesPreviewDetails.id,
            name: tvSeriesPreviewDetails.name,
            posterURL: tvSeriesPreviewDetails.posterURLSet?.thumbnail
        )
    }

}
