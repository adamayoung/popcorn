//
//  TVEpisodeDetailsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVEpisodeDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVEpisodeDetailsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct TVEpisodeDetailsDependencies: Sendable {

    public var fetchEpisode: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> TVEpisode

    public var fetchCredits: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> Credits

    public var isCastAndCrewEnabled: @Sendable () throws -> Bool

    public init(
        fetchEpisode: @escaping @Sendable (
            _ tvSeriesID: Int,
            _ seasonNumber: Int,
            _ episodeNumber: Int
        ) async throws -> TVEpisode,
        fetchCredits: @escaping @Sendable (
            _ tvSeriesID: Int,
            _ seasonNumber: Int,
            _ episodeNumber: Int
        ) async throws -> Credits,
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchEpisode = fetchEpisode
        self.fetchCredits = fetchCredits
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
    }

}

public extension TVEpisodeDetailsDependencies {

    /// Builds the production dependencies from the app's shared services,
    /// wiring the use cases, mappers, feature flag, and error wrapping.
    static func live(services: AppServices) -> TVEpisodeDetailsDependencies {
        let fetchTVEpisodeDetails = services.tvSeriesFactory.makeFetchTVEpisodeDetailsUseCase()
        let fetchTVEpisodeCredits = services.tvSeriesFactory.makeFetchTVEpisodeCreditsUseCase()
        let featureFlags = services.featureFlags

        return TVEpisodeDetailsDependencies(
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

}

#if DEBUG
    public extension TVEpisodeDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVEpisodeDetailsDependencies {
            TVEpisodeDetailsDependencies(
                fetchEpisode: { _, _, _ in TVEpisode.mock },
                fetchCredits: { _, _, _ in Credits.mock },
                isCastAndCrewEnabled: { true }
            )
        }

    }
#endif
