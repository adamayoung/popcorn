//
//  TVEpisodeDetailsClient.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import FeatureAccess
import Foundation

@DependencyClient
struct TVEpisodeDetailsClient: Sendable {

    var fetchEpisodeDetails: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> EpisodeDetails

    var fetchCredits: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> Credits

    var isCastAndCrewEnabled: @Sendable () throws -> Bool

}

extension TVEpisodeDetailsClient: DependencyKey {

    static var liveValue: TVEpisodeDetailsClient {
        @Dependency(\.fetchTVEpisodeDetails) var fetchTVEpisodeDetails
        @Dependency(\.fetchTVEpisodeCredits) var fetchTVEpisodeCredits
        @Dependency(\.featureFlags) var featureFlags

        return TVEpisodeDetailsClient(
            fetchEpisodeDetails: { tvSeriesID, seasonNumber, episodeNumber in
                let summary = try await fetchTVEpisodeDetails.execute(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
                let mapper = TVEpisodeMapper()
                return mapper.map(summary)
            },
            fetchCredits: { tvSeriesID, seasonNumber, episodeNumber in
                let creditsDetails = try await fetchTVEpisodeCredits.execute(
                    tvSeriesID: tvSeriesID,
                    seasonNumber: seasonNumber,
                    episodeNumber: episodeNumber
                )
                let mapper = CreditsMapper()
                return mapper.map(creditsDetails)
            },
            isCastAndCrewEnabled: {
                featureFlags.isEnabled(.tvEpisodeDetailsCastAndCrew)
            }
        )
    }

    static var previewValue: TVEpisodeDetailsClient {
        TVEpisodeDetailsClient(
            fetchEpisodeDetails: { _, _, _ in
                EpisodeDetails(
                    name: "Pilot",
                    overview: "A high school chemistry teacher diagnosed with lung cancer turns to manufacturing meth.",
                    airDate: Date(timeIntervalSince1970: 1_200_528_000),
                    stillURL: URL(
                        string: "https://image.tmdb.org/t/p/original/ydlY3iPfeOAvu8gVqrxPoMvzfBj.jpg"
                    )
                )
            },
            fetchCredits: { _, _, _ in
                Credits.mock
            },
            isCastAndCrewEnabled: {
                true
            }
        )
    }

}

extension DependencyValues {

    var tvEpisodeDetailsClient: TVEpisodeDetailsClient {
        get { self[TVEpisodeDetailsClient.self] }
        set { self[TVEpisodeDetailsClient.self] = newValue }
    }

}
