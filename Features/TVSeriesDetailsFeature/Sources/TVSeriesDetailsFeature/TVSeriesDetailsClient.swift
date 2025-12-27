//
//  TVSeriesDetailsClient.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import TVSeriesApplication

@DependencyClient
struct TVSeriesDetailsClient: Sendable {

    var fetch: @Sendable (Int) async throws -> TVSeries

    var isIntelligenceEnabled: @Sendable () throws -> Bool

}

extension TVSeriesDetailsClient: DependencyKey {

    static var liveValue: TVSeriesDetailsClient {
        @Dependency(\.fetchTVSeriesDetails) var fetchTVSeriesDetails
        @Dependency(\.featureFlags) var featureFlags

        return TVSeriesDetailsClient(
            fetch: { id in
                let span = SpanContext.startChild(
                    operation: .clientFetch,
                    description: "TVSeriesDetailsClient.fetch"
                )
                span?.setData(key: "tv_series_id", value: id)

                do {
                    let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                    let mapper = TVSeriesMapper()
                    let result = mapper.map(tvSeries)
                    span?.finish()
                    return result
                } catch let error {
                    span?.setData(error: error)
                    span?.finish(status: .internalError)
                    throw error
                }
            },
            isIntelligenceEnabled: {
                featureFlags.isEnabled(.tvSeriesIntelligence)
            }
        )
    }

    static var previewValue: TVSeriesDetailsClient {
        TVSeriesDetailsClient(
            fetch: { _ in
                try await Task.sleep(for: .seconds(2))
                return TVSeries.mock
            },
            isIntelligenceEnabled: {
                true
            }
        )
    }

}

extension DependencyValues {

    var tvSeriesDetailsClient: TVSeriesDetailsClient {
        get { self[TVSeriesDetailsClient.self] }
        set { self[TVSeriesDetailsClient.self] = newValue }
    }

}
