//
//  MockTVEpisodeLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

actor MockTVEpisodeLocalDataSource: TVEpisodeLocalDataSource {

    var episodeCallCount = 0
    var episodeCalledWith: [(episodeNumber: Int, seasonNumber: Int, tvSeriesID: Int)] = []
    nonisolated(unsafe) var episodeStub: Result<TVEpisode?, TVEpisodeLocalDataSourceError>?

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeLocalDataSourceError) -> TVEpisode? {
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

    var setEpisodeCallCount = 0
    var setEpisodeCalledWith: [(episode: TVEpisode, tvSeriesID: Int)] = []
    nonisolated(unsafe) var setEpisodeStub: Result<Void, TVEpisodeLocalDataSourceError>?

    func setEpisode(
        _ episode: TVEpisode,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeLocalDataSourceError) {
        setEpisodeCallCount += 1
        setEpisodeCalledWith.append((episode: episode, tvSeriesID: tvSeriesID))

        guard let stub = setEpisodeStub else {
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
