//
//  TVSeriesMapper.swift
//  TVSeriesDetailsDetailsFeature
//
//  Created by Adam Young on 20/11/2025.
//

import Foundation
import TVSeriesApplication

struct TVSeriesMapper {

    func map(_ tvSeriesDetails: TVSeriesDetails) -> TVSeries {
        TVSeries(
            id: tvSeriesDetails.id,
            name: tvSeriesDetails.name,
            overview: tvSeriesDetails.overview ?? "",
            posterURL: tvSeriesDetails.posterURLSet?.detail,
            backdropURL: tvSeriesDetails.backdropURLSet?.full,
            logoURL: tvSeriesDetails.logoURLSet?.detail
        )
    }

}
