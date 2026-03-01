//
//  MockTVEpisodeCreditsLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

actor MockTVEpisodeCreditsLocalDataSource: TVEpisodeCreditsLocalDataSource {

    nonisolated(unsafe) var creditsCallCount = 0
    nonisolated(unsafe) var creditsCalledWith: [(episodeNumber: Int, seasonNumber: Int, tvSeriesID: Int)] = []
    nonisolated(unsafe) var creditsStub: Result<Credits?, TVEpisodeCreditsLocalDataSourceError>?

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsLocalDataSourceError) -> Credits? {
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

    nonisolated(unsafe) var setCreditsCallCount = 0
    nonisolated(unsafe) var setCreditsCalledWith: [(
        credits: Credits,
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: Int
    )] = []
    nonisolated(unsafe) var setCreditsStub: Result<Void, TVEpisodeCreditsLocalDataSourceError>?

    func setCredits(
        _ credits: Credits,
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeCreditsLocalDataSourceError) {
        setCreditsCallCount += 1
        setCreditsCalledWith.append((
            credits: credits,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        ))

        if case .failure(let error) = setCreditsStub {
            throw error
        }
    }

}
