//
//  TVSeasonMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// Maps a context ``TVSeasonDetails`` to the feature's ``TVSeason`` presentation model.
public struct TVSeasonMapper {

    /// Creates a TV season mapper.
    public init() {}

    /// Maps a context ``TVSeasonDetails`` to a presentation ``TVSeason``.
    public func map(_ details: TVSeasonDetails) -> TVSeason {
        TVSeason(
            id: details.id,
            seasonNumber: details.seasonNumber,
            tvSeriesID: details.tvSeriesID,
            name: details.name,
            tvSeriesName: details.tvSeriesName,
            posterURL: details.posterURLSet?.thumbnail,
            overview: details.overview
        )
    }

}
