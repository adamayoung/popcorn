//
//  TVSeriesDetailsClient.swift
//  TVSeriesDetailsFeature
//
//  Created by Adam Young on 18/11/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import TVSeriesApplication

@DependencyClient
struct TVSeriesDetailsClient: Sendable {

    var fetch: @Sendable (Int) async throws -> TVSeries

}

extension TVSeriesDetailsClient: DependencyKey {

    static var liveValue: TVSeriesDetailsClient {
        @Dependency(\.fetchTVSeriesDetails) var fetchTVSeriesDetails

        return TVSeriesDetailsClient(
            fetch: { id in
                let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                let mapper = TVSeriesMapper()
                return mapper.map(tvSeries)
            }
        )
    }

    static var previewValue: TVSeriesDetailsClient {
        TVSeriesDetailsClient(
            fetch: { _ in
                try await Task.sleep(for: .seconds(2))
                return TVSeries.mock
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
