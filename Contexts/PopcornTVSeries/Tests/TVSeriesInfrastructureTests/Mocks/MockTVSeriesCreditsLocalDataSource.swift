//
//  MockTVSeriesCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

actor MockTVSeriesCreditsLocalDataSource: TVSeriesCreditsLocalDataSource {

    nonisolated(unsafe) var creditsCallCount = 0
    nonisolated(unsafe) var creditsCalledWith: [Int] = []
    nonisolated(unsafe) var creditsStub: Result<Credits?, TVSeriesCreditsLocalDataSourceError>?

    func credits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsLocalDataSourceError) -> Credits? {
        creditsCallCount += 1
        creditsCalledWith.append(tvSeriesID)

        guard let stub = creditsStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

    nonisolated(unsafe) var setCreditsCallCount = 0
    nonisolated(unsafe) var setCreditsCalledWith: [(credits: Credits, tvSeriesID: Int)] = []
    nonisolated(unsafe) var setCreditsStub: Result<Void, TVSeriesCreditsLocalDataSourceError>?

    func setCredits(
        _ credits: Credits,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesCreditsLocalDataSourceError) {
        setCreditsCallCount += 1
        setCreditsCalledWith.append((credits: credits, tvSeriesID: tvSeriesID))

        if case .failure(let error) = setCreditsStub {
            throw error
        }
    }

}
