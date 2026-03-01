//
//  TVEpisodeCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVEpisodeCreditsLocalDataSource: Sendable, Actor {

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsLocalDataSourceError) -> Credits?

    func setCredits(
        _ credits: Credits,
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsLocalDataSourceError)

}

public enum TVEpisodeCreditsLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
