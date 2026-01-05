//
//  TrendingTVSeriesClient.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import TrendingApplication

@DependencyClient
struct TrendingTVSeriesClient: Sendable {

    var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]

}

extension TrendingTVSeriesClient: DependencyKey {

    static var liveValue: TrendingTVSeriesClient {
        @Dependency(\.fetchTrendingTVSeries) var fetchTrendingTVSeries

        return TrendingTVSeriesClient(
            fetchTrendingTVSeries: {
                let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                let mapper = TVSeriesPreviewMapper()
                return tvSeriesPreviews.map(mapper.map)
            }
        )
    }

    static var previewValue: TrendingTVSeriesClient {
        TrendingTVSeriesClient(
            fetchTrendingTVSeries: {
                TVSeriesPreview.mocks
            }
        )
    }

}

extension DependencyValues {

    var trendingTVSeriesClient: TrendingTVSeriesClient {
        get {
            self[TrendingTVSeriesClient.self]
        }
        set {
            self[TrendingTVSeriesClient.self] = newValue
        }
    }

}
