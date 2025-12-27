//
//  TVSeriesDetailsClient.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
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
                let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                let mapper = TVSeriesMapper()
                return mapper.map(tvSeries)
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
