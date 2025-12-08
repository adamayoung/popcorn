//
//  TrendingPeopleClient.swift
//  TrendingPeopleFeature
//
//  Created by Adam Young on 19/11/2025.
//

import ComposableArchitecture
import Foundation
import TrendingApplication
import TrendingKitAdapters

struct TrendingPeopleClient: Sendable {

    var fetch: @Sendable () async throws -> [PersonPreview]

}

extension TrendingPeopleClient: DependencyKey {

    static var liveValue: TrendingPeopleClient {
        TrendingPeopleClient(
            fetch: {
                let useCase = DependencyValues._current.fetchTrendingPeople
                let personPreviews = try await useCase.execute()
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
                        id: 234352,
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
