//
//  TVEpisodeMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// Maps a context ``TVEpisodeSummary`` to the feature's ``TVEpisode`` presentation model.
public struct TVEpisodeMapper {

    /// Creates a TV episode mapper.
    public init() {}

    /// Maps a context ``TVEpisodeSummary`` to a presentation ``TVEpisode``.
    public func map(_ summary: TVEpisodeSummary) -> TVEpisode {
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
