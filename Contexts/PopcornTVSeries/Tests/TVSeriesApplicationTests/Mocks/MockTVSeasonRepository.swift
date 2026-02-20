//
//  MockTVSeasonRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class MockTVSeasonRepository: TVSeasonRepository, @unchecked Sendable {

    var seasonCallCount = 0
    var seasonCalledWith: [(seasonNumber: Int, tvSeriesID: Int)] = []
    var seasonStub: Result<TVSeason, TVSeasonRepositoryError>?

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonRepositoryError) -> TVSeason {
        seasonCallCount += 1
        seasonCalledWith.append((seasonNumber: seasonNumber, tvSeriesID: tvSeriesID))

        guard let stub = seasonStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let season):
            return season
        case .failure(let error):
            throw error
        }
    }

}
