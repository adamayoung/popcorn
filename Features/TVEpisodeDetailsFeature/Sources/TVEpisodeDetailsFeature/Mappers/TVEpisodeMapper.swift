//
//  TVEpisodeMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// Maps a context ``TVEpisodeDetails`` to the feature's ``TVEpisode`` presentation model.
public struct TVEpisodeMapper {

    /// Creates a TV episode mapper.
    public init() {}

    /// Maps a context ``TVEpisodeDetails`` to a presentation ``TVEpisode``.
    public func map(_ details: TVEpisodeDetails) -> TVEpisode {
        TVEpisode(
            id: details.id,
            name: details.name,
            episodeNumber: details.episodeNumber,
            seasonNumber: details.seasonNumber,
            tvSeasonID: details.tvSeasonID,
            tvSeriesID: details.tvSeriesID,
            overview: details.overview,
            airDate: details.airDate,
            stillURL: details.stillURLSet?.full
        )
    }

}
