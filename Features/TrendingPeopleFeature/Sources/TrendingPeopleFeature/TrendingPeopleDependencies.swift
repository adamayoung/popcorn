//
//  TrendingPeopleDependencies.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``TrendingPeopleViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TrendingPeopleViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct TrendingPeopleDependencies: Sendable {

    public var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

    public init(
        fetchTrendingPeople: @escaping @Sendable () async throws -> [PersonPreview]
    ) {
        self.fetchTrendingPeople = fetchTrendingPeople
    }

}

#if DEBUG
    public extension TrendingPeopleDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TrendingPeopleDependencies {
            TrendingPeopleDependencies(
                fetchTrendingPeople: { PersonPreview.mocks }
            )
        }

    }
#endif
