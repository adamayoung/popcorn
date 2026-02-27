//
//  TVEpisodeLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVEpisodeLocalDataSource: Sendable, Actor {

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeLocalDataSourceError) -> TVEpisode?

    func setEpisode(
        _ episode: TVEpisode,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeLocalDataSourceError)

}

public enum TVEpisodeLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
