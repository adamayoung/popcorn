//
//  TVSeriesPreviewMapper.swift
//  TrendingTVSeriesFeature
//
//  Created by Adam Young on 21/11/2025.
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
