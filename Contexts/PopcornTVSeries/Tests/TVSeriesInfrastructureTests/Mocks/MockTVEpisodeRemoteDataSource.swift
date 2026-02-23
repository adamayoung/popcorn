//
//  MockTVEpisodeRemoteDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

final class MockTVEpisodeRemoteDataSource: TVEpisodeRemoteDataSource, @unchecked Sendable {

    var episodeCallCount = 0
    var episodeCalledWith: [(episodeNumber: Int, seasonNumber: Int, tvSeriesID: Int)] = []
    var episodeStub: Result<TVEpisode, TVEpisodeRemoteDataSourceError>?

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeRemoteDataSourceError) -> TVEpisode {
        episodeCallCount += 1
        episodeCalledWith.append((
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        ))

        guard let stub = episodeStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let episode):
            return episode
        case .failure(let error):
            throw error
        }
    }

}
