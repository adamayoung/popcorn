//
//  TrendingPeopleClient.swift
//  Popcorn
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

    var fetch: @Sendable () async throws -> [PersonPreview]

}

extension TrendingPeopleClient: DependencyKey {

    static var liveValue: TrendingPeopleClient {
        @Dependency(\.fetchTrendingPeople) var fetchTrendingPeople

        return TrendingPeopleClient(
            fetch: {
                let personPreviews = try await fetchTrendingPeople.execute()
                let mapper = PersonPreviewMapper()
                return personPreviews.map(mapper.map)
            }
        )
    }

    static var previewValue: TrendingPeopleClient {
        TrendingPeopleClient(
            fetch: {
                [
                    PersonPreview(
                        id: 234_352,
                        name: "Margot Robbie",
                        profileURL: URL(
                            string:
                            "https://image.tmdb.org/t/p/h632/euDPyqLnuwaWMHajcU3oZ9uZezR.jpg")
                    ),
                    PersonPreview(
                        id: 2283,
                        name: "Stanley Tucci",
                        profileURL: URL(
                            string:
                            "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg")
                    )
                ]
            }
        )
    }

}

extension DependencyValues {

    var trendingPeople: TrendingPeopleClient {
        get {
            self[TrendingPeopleClient.self]
        }
        set {
            self[TrendingPeopleClient.self] = newValue
        }
    }

}
