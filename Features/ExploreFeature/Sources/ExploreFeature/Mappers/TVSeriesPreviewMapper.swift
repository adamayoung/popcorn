//
//  TVSeriesPreviewMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingApplication

struct TVSeriesPreviewMapper {

    func map(_ tvSeriesPreviewDetails: TVSeriesPreviewDetails) -> TVSeriesPreview {
        TVSeriesPreview(
            id: tvSeriesPreviewDetails.id,
            name: tvSeriesPreviewDetails.name,
            posterURL: tvSeriesPreviewDetails.posterURLSet?.detail,
            backdropURL: tvSeriesPreviewDetails.backdropURLSet?.detail
        )
    }

}
