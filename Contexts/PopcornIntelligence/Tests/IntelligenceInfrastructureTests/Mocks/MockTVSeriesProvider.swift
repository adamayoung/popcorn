//
//  MockTVSeriesProvider.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

final class MockTVSeriesProvider: TVSeriesProviding, @unchecked Sendable {

    var tvSeriesCallCount = 0
    var tvSeriesCalledWith: [Int] = []
    var tvSeriesStub: Result<TVSeries, TVSeriesProviderError>?

    func tvSeries(withID id: Int) async throws(TVSeriesProviderError) -> TVSeries {
        tvSeriesCallCount += 1
        tvSeriesCalledWith.append(id)

        guard let stub = tvSeriesStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let tvSeries):
            return tvSeries
        case .failure(let error):
            throw error
        }
    }

}
