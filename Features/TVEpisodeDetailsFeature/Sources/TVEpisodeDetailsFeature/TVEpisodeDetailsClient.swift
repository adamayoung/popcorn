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
import TVSeriesApplication

@DependencyClient
struct TVEpisodeDetailsClient: Sendable {

    var fetchEpisode: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> TVEpisode

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
            fetchEpisode: { tvSeriesID, seasonNumber, episodeNumber in
                do {
                    let details = try await fetchTVEpisodeDetails.execute(
                        tvSeriesID: tvSeriesID,
                        seasonNumber: seasonNumber,
                        episodeNumber: episodeNumber
                    )
                    let mapper = TVEpisodeMapper()
                    return mapper.map(details)
                } catch let error as FetchTVEpisodeDetailsError {
                    throw FetchEpisodeDetailsError(error)
                }
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
            fetchEpisode: { _, _, _ in
                TVEpisode.mock
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
