//
//  MockTVSeriesCreditsRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class MockTVSeriesCreditsRepository: TVSeriesCreditsRepository, @unchecked Sendable {

    var creditsCallCount = 0
    var creditsCalledWith: [Int] = []
    var creditsStub: Result<Credits, TVSeriesCreditsRepositoryError>?

    func credits(forTVSeries tvSeriesID: Int) async throws(TVSeriesCreditsRepositoryError)
    -> Credits {
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

    var aggregateCreditsCallCount = 0
    var aggregateCreditsCalledWith: [Int] = []
    var aggregateCreditsStub: Result<AggregateCredits, TVSeriesCreditsRepositoryError>?

    func aggregateCredits(forTVSeries tvSeriesID: Int)
    async throws(TVSeriesCreditsRepositoryError) -> AggregateCredits {
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

}
