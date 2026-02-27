//
//  MockTVSeasonLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

actor MockTVSeasonLocalDataSource: TVSeasonLocalDataSource {

    var seasonCallCount = 0
    var seasonCalledWith: [(seasonNumber: Int, tvSeriesID: Int)] = []
    nonisolated(unsafe) var seasonStub: Result<TVSeason?, TVSeasonLocalDataSourceError>?

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonLocalDataSourceError) -> TVSeason? {
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

    var setSeasonCallCount = 0
    var setSeasonCalledWith: [(season: TVSeason, tvSeriesID: Int)] = []
    nonisolated(unsafe) var setSeasonStub: Result<Void, TVSeasonLocalDataSourceError>?

    func setSeason(
        _ season: TVSeason,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonLocalDataSourceError) {
        setSeasonCallCount += 1
        setSeasonCalledWith.append((season: season, tvSeriesID: tvSeriesID))

        guard let stub = setSeasonStub else {
            return
        }

        switch stub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

}
