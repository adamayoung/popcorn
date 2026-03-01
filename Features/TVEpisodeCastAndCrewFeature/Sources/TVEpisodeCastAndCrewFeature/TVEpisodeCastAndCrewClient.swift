//
//  TVEpisodeCastAndCrewClient.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation

@DependencyClient
struct TVEpisodeCastAndCrewClient: Sendable {

    var fetchCredits: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> Credits

}

extension TVEpisodeCastAndCrewClient: DependencyKey {

    static var liveValue: TVEpisodeCastAndCrewClient {
        @Dependency(\.fetchTVEpisodeCredits) var fetchTVEpisodeCredits

        return TVEpisodeCastAndCrewClient(
            fetchCredits: { tvSeriesID, seasonNumber, episodeNumber in
                let creditsDetails = try await fetchTVEpisodeCredits
                    .execute(
                        tvSeriesID: tvSeriesID,
                        seasonNumber: seasonNumber,
                        episodeNumber: episodeNumber
                    )
                let mapper = CreditsMapper()
                return mapper.map(creditsDetails)
            }
        )
    }

    static var previewValue: TVEpisodeCastAndCrewClient {
        TVEpisodeCastAndCrewClient(
            fetchCredits: { _, _, _ in
                Credits.mock
            }
        )
    }

}

extension DependencyValues {

    var tvEpisodeCastAndCrewClient: TVEpisodeCastAndCrewClient {
        get { self[TVEpisodeCastAndCrewClient.self] }
        set { self[TVEpisodeCastAndCrewClient.self] = newValue }
    }

}
