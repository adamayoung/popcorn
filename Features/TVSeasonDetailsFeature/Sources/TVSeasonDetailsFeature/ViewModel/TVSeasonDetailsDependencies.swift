//
//  TVSeasonDetailsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVSeasonDetailsViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TVSeasonDetailsClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
public struct TVSeasonDetailsDependencies: Sendable {

    public var fetchSeasonAndEpisodes: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int
    ) async throws -> (TVSeason, [TVEpisode])

    public init(
        fetchSeasonAndEpisodes: @escaping @Sendable (
            _ tvSeriesID: Int,
            _ seasonNumber: Int
        ) async throws -> (TVSeason, [TVEpisode])
    ) {
        self.fetchSeasonAndEpisodes = fetchSeasonAndEpisodes
    }

}

public extension TVSeasonDetailsDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TVSeasonDetailsClient.liveValue` exactly: same use case,
    /// same mappers, same error wrapping.
    static func live(services: AppServices) -> TVSeasonDetailsDependencies {
        let fetchTVSeasonDetails = services.tvSeriesFactory.makeFetchTVSeasonDetailsUseCase()

        return TVSeasonDetailsDependencies(
            fetchSeasonAndEpisodes: { tvSeriesID, seasonNumber in
                do {
                    let details = try await fetchTVSeasonDetails.execute(
                        tvSeriesID: tvSeriesID,
                        seasonNumber: seasonNumber
                    )
                    let seasonMapper = TVSeasonMapper()
                    let episodeMapper = TVEpisodeMapper()

                    let season = seasonMapper.map(details)
                    let episodes = details.episodes.map(episodeMapper.map)

                    return (season, episodes)
                } catch let error as FetchTVSeasonDetailsError {
                    throw FetchSeasonDetailsError(error)
                }
            }
        )
    }

}

#if DEBUG
    public extension TVSeasonDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `TVSeasonDetailsClient.previewValue`).
        static var preview: TVSeasonDetailsDependencies {
            TVSeasonDetailsDependencies(
                fetchSeasonAndEpisodes: { _, _ in
                    (TVSeason.mock, TVEpisode.mocks)
                }
            )
        }

    }
#endif
