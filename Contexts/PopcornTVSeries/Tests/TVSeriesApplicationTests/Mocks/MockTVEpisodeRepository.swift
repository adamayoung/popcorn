//
//  MockTVEpisodeRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class MockTVEpisodeRepository: TVEpisodeRepository, @unchecked Sendable {

    var episodeCallCount = 0
    var episodeCalledWith: [(episodeNumber: Int, seasonNumber: Int, tvSeriesID: Int)] = []
    var episodeStub: Result<TVEpisode, TVEpisodeRepositoryError>?

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeRepositoryError) -> TVEpisode {
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
