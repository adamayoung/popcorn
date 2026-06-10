//
//  TrendingPeopleDependencies.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TrendingApplication

/// The dependencies required by ``TrendingPeopleViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TrendingPeopleViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct TrendingPeopleDependencies: Sendable {

    public var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

    public init(
        fetchTrendingPeople: @escaping @Sendable () async throws -> [PersonPreview]
    ) {
        self.fetchTrendingPeople = fetchTrendingPeople
    }

}

public extension TrendingPeopleDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the trending use case and maps results to ``PersonPreview`` values.
    static func live(services: AppServices) -> TrendingPeopleDependencies {
        let fetchTrendingPeople = services.trendingFactory.makeFetchTrendingPeopleUseCase()

        return TrendingPeopleDependencies(
            fetchTrendingPeople: {
                let personPreviews = try await fetchTrendingPeople.execute()
                let mapper = PersonPreviewMapper()
                return personPreviews.map(mapper.map)
            }
        )
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
