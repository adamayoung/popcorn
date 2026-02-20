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

    var fetchSeasonDetails: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int
    ) async throws -> SeasonDetails

}

extension TVSeasonDetailsClient: DependencyKey {

    static var liveValue: TVSeasonDetailsClient {
        @Dependency(\.fetchTVSeasonDetails) var fetchTVSeasonDetails

        return TVSeasonDetailsClient(
            fetchSeasonDetails: { tvSeriesID, seasonNumber in
                let summary = try await fetchTVSeasonDetails.execute(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber
                )
                let mapper = TVEpisodeMapper()
                let episodes = summary.episodes.map(mapper.map)
                return SeasonDetails(
                    overview: summary.overview,
                    episodes: episodes
                )
            }
        )
    }

    static var previewValue: TVSeasonDetailsClient {
        TVSeasonDetailsClient(
            fetchSeasonDetails: { _, _ in
                SeasonDetails(
                    overview: "The first season of Breaking Bad.",
                    episodes: TVEpisode.mocks
                )
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
