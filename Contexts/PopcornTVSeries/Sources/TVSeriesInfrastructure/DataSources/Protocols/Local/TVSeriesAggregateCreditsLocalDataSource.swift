//
//  TVSeriesAggregateCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

public protocol TVSeriesAggregateCreditsLocalDataSource: Sendable, Actor {

    func aggregateCredits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesAggregateCreditsLocalDataSourceError) -> AggregateCredits?

    func setAggregateCredits(
        _ aggregateCredits: AggregateCredits,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesAggregateCreditsLocalDataSourceError)

}

public enum TVSeriesAggregateCreditsLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
