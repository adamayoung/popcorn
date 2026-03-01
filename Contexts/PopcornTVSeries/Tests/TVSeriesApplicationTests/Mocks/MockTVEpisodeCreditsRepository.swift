//
//  MockTVEpisodeCreditsRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class MockTVEpisodeCreditsRepository: TVEpisodeCreditsRepository, @unchecked Sendable {

    var creditsCallCount = 0
    var creditsCalledWith: [(episodeNumber: Int, seasonNumber: Int, tvSeriesID: Int)] = []
    var creditsStub: Result<Credits, TVEpisodeCreditsRepositoryError>?

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsRepositoryError) -> Credits {
        creditsCallCount += 1
        creditsCalledWith.append((episodeNumber: episodeNumber, seasonNumber: seasonNumber, tvSeriesID: tvSeriesID))

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

}
