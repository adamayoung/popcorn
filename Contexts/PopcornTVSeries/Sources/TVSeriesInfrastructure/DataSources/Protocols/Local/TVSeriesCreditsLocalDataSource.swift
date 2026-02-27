//
//  TVSeriesCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVSeriesCreditsLocalDataSource: Sendable, Actor {

    func credits(forTVSeries tvSeriesID: Int) async throws(TVSeriesCreditsLocalDataSourceError)
        -> Credits?

    func setCredits(
        _ credits: Credits,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsLocalDataSourceError)

}

public enum TVSeriesCreditsLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
