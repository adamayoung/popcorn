//
//  TrendingPeopleClient.swift
//  TrendingPeopleFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import PopcornTrendingAdapters
import TrendingApplication

@DependencyClient
struct TrendingPeopleClient: Sendable {

    var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

}

extension TrendingPeopleClient: DependencyKey {

    static var liveValue: TrendingPeopleClient {
        @Dependency(\.fetchTrendingPeople) var fetchTrendingPeople

        return TrendingPeopleClient(
            fetchTrendingPeople: {
                let personPreviews = try await fetchTrendingPeople.execute()
                let mapper = PersonPreviewMapper()
                return personPreviews.map(mapper.map)
            }
        )
    }

    static var previewValue: TrendingPeopleClient {
        TrendingPeopleClient(
            fetchTrendingPeople: {
                PersonPreview.mocks
            }
        )
    }

}

extension DependencyValues {

    var trendingPeopleClient: TrendingPeopleClient {
        get {
            self[TrendingPeopleClient.self]
        }
        set {
            self[TrendingPeopleClient.self] = newValue
        }
    }

}
