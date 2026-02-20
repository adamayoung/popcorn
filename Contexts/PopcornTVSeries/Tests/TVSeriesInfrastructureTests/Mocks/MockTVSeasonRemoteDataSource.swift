//
//  MockTVSeasonRemoteDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

final class MockTVSeasonRemoteDataSource: TVSeasonRemoteDataSource, @unchecked Sendable {

    var seasonCallCount = 0
    var seasonCalledWith: [(seasonNumber: Int, tvSeriesID: Int)] = []
    var seasonStub: Result<TVSeason, TVSeasonRemoteDataSourceError>?

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonRemoteDataSourceError) -> TVSeason {
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
