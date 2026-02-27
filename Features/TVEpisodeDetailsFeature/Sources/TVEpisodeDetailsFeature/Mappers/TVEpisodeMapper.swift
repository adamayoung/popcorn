//
//  TVEpisodeMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct TVEpisodeMapper {

    func map(_ summary: TVEpisodeSummary) -> EpisodeDetails {
        EpisodeDetails(
            name: summary.name,
            overview: summary.overview,
            airDate: summary.airDate,
            stillURL: summary.stillURLSet?.full
        )
    }

}
