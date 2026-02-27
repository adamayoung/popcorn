//
//  TVSeasonLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVSeasonLocalDataSource: Sendable, Actor {

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonLocalDataSourceError) -> TVSeason?

    func setSeason(
        _ season: TVSeason,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonLocalDataSourceError)

}

public enum TVSeasonLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
