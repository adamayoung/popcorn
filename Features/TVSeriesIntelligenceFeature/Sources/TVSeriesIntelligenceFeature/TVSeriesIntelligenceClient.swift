//
//  TVSeriesIntelligenceClient.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import IntelligenceDomain
import TVSeriesApplication

@DependencyClient
struct TVSeriesIntelligenceClient: Sendable {

    var fetchTVSeries: @Sendable (_ id: Int) async throws -> TVSeries
    var createSession: @Sendable (_ tvSeriesID: Int) async throws -> LLMSession

}

extension TVSeriesIntelligenceClient: DependencyKey {

    static var liveValue: TVSeriesIntelligenceClient {
        @Dependency(\.fetchTVSeriesDetails) var fetchTVSeriesDetails
        @Dependency(\.createTVSeriesIntelligenceSession) var createTVSeriesIntelligenceSession

        return TVSeriesIntelligenceClient(
            fetchTVSeries: { id in
                let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                let mapper = TVSeriesMapper()
                return mapper.map(tvSeries)
            },
            createSession: { tvSeriesID in
                try await createTVSeriesIntelligenceSession.execute(tvSeriesID: tvSeriesID)
            }
        )
    }

}

extension DependencyValues {

    var tvSeriesIntelligenceClient: TVSeriesIntelligenceClient {
        get {
            self[TVSeriesIntelligenceClient.self]
        }
        set {
            self[TVSeriesIntelligenceClient.self] = newValue
        }
    }

}
