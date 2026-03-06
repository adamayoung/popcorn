//
//  TVSeasonDetailsClient.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation

@DependencyClient
struct TVSeasonDetailsClient: Sendable {

    var fetchSeasonAndEpisodes: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int
    ) async throws -> (TVSeason, [TVEpisode])

}

extension TVSeasonDetailsClient: DependencyKey {

    static var liveValue: TVSeasonDetailsClient {
        @Dependency(\.fetchTVSeasonDetails) var fetchTVSeasonDetails

        return TVSeasonDetailsClient(
            fetchSeasonAndEpisodes: { tvSeriesID, seasonNumber in
                let details = try await fetchTVSeasonDetails.execute(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber
                )
                let seasonMapper = TVSeasonMapper()
                let episodeMapper = TVEpisodeMapper()

                let season = seasonMapper.map(details)
                let episodes = details.episodes.map(episodeMapper.map)

                return (season, episodes)
            }
        )
    }

    static var previewValue: TVSeasonDetailsClient {
        TVSeasonDetailsClient(
            fetchSeasonAndEpisodes: { _, _ in
                (TVSeason.mock, TVEpisode.mocks)
            }
        )
    }

}

extension DependencyValues {

    var tvSeasonDetailsClient: TVSeasonDetailsClient {
        get { self[TVSeasonDetailsClient.self] }
        set { self[TVSeasonDetailsClient.self] = newValue }
    }

}
