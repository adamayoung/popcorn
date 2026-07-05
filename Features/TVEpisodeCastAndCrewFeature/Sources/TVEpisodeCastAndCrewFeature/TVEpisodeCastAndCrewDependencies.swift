//
//  TVEpisodeCastAndCrewDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``TVEpisodeCastAndCrewViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVEpisodeCastAndCrewViewModel``. Constructing it requires every closure,
/// so a missing dependency is a compile error. The production instance is built
/// by the app's composition layer; use ``preview`` for previews and tests.
public struct TVEpisodeCastAndCrewDependencies: Sendable {

    public var fetchCredits: @Sendable (
        _ tvSeriesID: Int,
        _ seasonNumber: Int,
        _ episodeNumber: Int
    ) async throws -> Credits

    public init(
        fetchCredits: @escaping @Sendable (
            _ tvSeriesID: Int,
            _ seasonNumber: Int,
            _ episodeNumber: Int
        ) async throws -> Credits
    ) {
        self.fetchCredits = fetchCredits
    }

}

#if DEBUG
    public extension TVEpisodeCastAndCrewDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVEpisodeCastAndCrewDependencies {
            TVEpisodeCastAndCrewDependencies(
                fetchCredits: { _, _, _ in Credits.mock }
            )
        }

    }
#endif
