//
//  MockTVSeriesAggregateCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

actor MockTVSeriesAggregateCreditsLocalDataSource: TVSeriesAggregateCreditsLocalDataSource {

    nonisolated(unsafe) var aggregateCreditsCallCount = 0
    nonisolated(unsafe) var aggregateCreditsCalledWith: [Int] = []
    nonisolated(unsafe) var aggregateCreditsStub:
        Result<AggregateCredits?, TVSeriesAggregateCreditsLocalDataSourceError>?

    func aggregateCredits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesAggregateCreditsLocalDataSourceError) -> AggregateCredits? {
        aggregateCreditsCallCount += 1
        aggregateCreditsCalledWith.append(tvSeriesID)

        guard let stub = aggregateCreditsStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    nonisolated(unsafe) var setAggregateCreditsCallCount = 0
    nonisolated(unsafe) var setAggregateCreditsCalledWith:
        [(aggregateCredits: AggregateCredits, tvSeriesID: Int)] = []
    nonisolated(unsafe) var setAggregateCreditsStub:
        Result<Void, TVSeriesAggregateCreditsLocalDataSourceError>?

    func setAggregateCredits(
        _ aggregateCredits: AggregateCredits,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesAggregateCreditsLocalDataSourceError) {
        setAggregateCreditsCallCount += 1
        setAggregateCreditsCalledWith.append(
            (aggregateCredits: aggregateCredits, tvSeriesID: tvSeriesID)
        )

        if case .failure(let error) = setAggregateCreditsStub {
            throw error
        }
    }

}
