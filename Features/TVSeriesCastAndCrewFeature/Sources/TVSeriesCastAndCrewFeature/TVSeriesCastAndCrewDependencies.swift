//
//  TVSeriesCastAndCrewDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``TVSeriesCastAndCrewViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVSeriesCastAndCrewViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the
/// app's composition layer; use ``preview`` for previews and tests.
public struct TVSeriesCastAndCrewDependencies: Sendable {

    public var fetchCredits: @Sendable (_ tvSeriesID: Int) async throws -> Credits

    public init(
        fetchCredits: @escaping @Sendable (_ tvSeriesID: Int) async throws -> Credits
    ) {
        self.fetchCredits = fetchCredits
    }

}

#if DEBUG
    public extension TVSeriesCastAndCrewDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVSeriesCastAndCrewDependencies {
            TVSeriesCastAndCrewDependencies(
                fetchCredits: { _ in Credits.mock }
            )
        }

    }
#endif
