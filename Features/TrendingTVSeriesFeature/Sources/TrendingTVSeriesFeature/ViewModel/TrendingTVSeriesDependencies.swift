//
//  TrendingTVSeriesDependencies.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import TrendingApplication

/// The dependencies required by ``TrendingTVSeriesViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TrendingTVSeriesClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
public struct TrendingTVSeriesDependencies: Sendable {

    public var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]

    public init(
        fetchTrendingTVSeries: @escaping @Sendable () async throws -> [TVSeriesPreview]
    ) {
        self.fetchTrendingTVSeries = fetchTrendingTVSeries
    }

}

public extension TrendingTVSeriesDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TrendingTVSeriesClient.liveValue` exactly: same use case,
    /// same mapper.
    static func live(services: AppServices) -> TrendingTVSeriesDependencies {
        let fetchTrendingTVSeries = services.trendingFactory.makeFetchTrendingTVSeriesUseCase()

        return TrendingTVSeriesDependencies(
            fetchTrendingTVSeries: {
                let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                let mapper = TVSeriesPreviewMapper()
                return tvSeriesPreviews.map(mapper.map)
            }
        )
    }

}

#if DEBUG
    public extension TrendingTVSeriesDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `TrendingTVSeriesClient.previewValue`).
        static var preview: TrendingTVSeriesDependencies {
            TrendingTVSeriesDependencies(
                fetchTrendingTVSeries: { TVSeriesPreview.mocks }
            )
        }

    }
#endif
