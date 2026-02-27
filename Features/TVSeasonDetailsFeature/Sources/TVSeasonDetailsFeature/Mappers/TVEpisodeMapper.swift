//
//  TVEpisodeMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct TVEpisodeMapper {

    func map(_ summary: TVEpisodeSummary) -> TVEpisode {
        TVEpisode(
            id: summary.id,
            name: summary.name,
            episodeNumber: summary.episodeNumber,
            overview: summary.overview,
            airDate: summary.airDate,
            stillURL: summary.stillURLSet?.card
        )
    }

}
