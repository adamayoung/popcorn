//
//  TVSeasonDetailsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVSeasonDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVSeasonDetailsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
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

#if DEBUG
    public extension TVSeasonDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVSeasonDetailsDependencies {
            TVSeasonDetailsDependencies(
                fetchSeasonAndEpisodes: { _, _ in
                    (TVSeason.mock, TVEpisode.mocks)
                }
            )
        }

    }
#endif
