//
//  TVSeasonPreviewMapper.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import TVSeriesApplication

struct TVSeasonPreviewMapper {

    func map(_ tvSeasonSummary: TVSeasonSummary) -> TVSeasonPreview {
        TVSeasonPreview(
            id: tvSeasonSummary.id,
            seasonNumber: tvSeasonSummary.seasonNumber,
            name: tvSeasonSummary.name,
            posterURL: tvSeasonSummary.posterURLSet?.detail
        )
    }

}
