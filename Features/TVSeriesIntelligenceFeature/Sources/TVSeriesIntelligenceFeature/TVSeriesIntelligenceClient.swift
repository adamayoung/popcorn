//
//  TVSeriesIntelligenceClient.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import IntelligenceDomain

@DependencyClient
struct TVSeriesIntelligenceClient: Sendable {

    var createSession: @Sendable (_ tvSeriesID: Int) async throws -> LLMSession

}

extension TVSeriesIntelligenceClient: DependencyKey {

    static var liveValue: TVSeriesIntelligenceClient {
        @Dependency(\.createTVSeriesIntelligenceSession) var createTVSeriesIntelligenceSession

        return TVSeriesIntelligenceClient(
            createSession: { tvSeriesID in
                let session = try await createTVSeriesIntelligenceSession.execute(tvSeriesID: tvSeriesID)
                return session
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
