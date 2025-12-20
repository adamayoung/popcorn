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

    var fetch: @Sendable () async throws -> [TVSeriesPreview]

}

extension TrendingTVSeriesClient: DependencyKey {

    static var liveValue: TrendingTVSeriesClient {
        @Dependency(\.fetchTrendingTVSeries) var fetchTrendingTVSeries

        return TrendingTVSeriesClient(
            fetch: {
                let tvSeriesPreviews = try await fetchTrendingTVSeries.execute()
                let mapper = TVSeriesPreviewMapper()
                return tvSeriesPreviews.map(mapper.map)
            }
        )
    }

    static var previewValue: TrendingTVSeriesClient {
        TrendingTVSeriesClient(
            fetch: {
                [
                    TVSeriesPreview(
                        id: 225_171,
                        name: "Pluribus",
                        posterURL: URL(
                            string:
                            "https://image.tmdb.org/t/p/w780/nrM2xFUfKJJEmZzd5d7kohT2G0C.jpg")
                    ),
                    TVSeriesPreview(
                        id: 66732,
                        name: "Stranger Things",
                        posterURL: URL(
                            string:
                            "https://image.tmdb.org/t/p/w780/cVxVGwHce6xnW8UaVUggaPXbmoE.jpg")
                    )
                ]
            }
        )
    }

}

extension DependencyValues {

    var trendingTVSeries: TrendingTVSeriesClient {
        get {
            self[TrendingTVSeriesClient.self]
        }
        set {
            self[TrendingTVSeriesClient.self] = newValue
        }
    }

}
