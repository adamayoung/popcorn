//
//  TVEpisodeDetailsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVEpisodeDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVEpisodeDetailsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
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
