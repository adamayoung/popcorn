//
//  TrendingTVSeriesDependencies.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``TrendingTVSeriesViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TrendingTVSeriesViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct TrendingTVSeriesDependencies: Sendable {

    public var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]

    public init(
        fetchTrendingTVSeries: @escaping @Sendable () async throws -> [TVSeriesPreview]
    ) {
        self.fetchTrendingTVSeries = fetchTrendingTVSeries
    }

}

#if DEBUG
    public extension TrendingTVSeriesDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TrendingTVSeriesDependencies {
            TrendingTVSeriesDependencies(
                fetchTrendingTVSeries: { TVSeriesPreview.mocks }
            )
        }

    }
#endif
