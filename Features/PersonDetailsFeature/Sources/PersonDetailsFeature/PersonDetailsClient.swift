//
//  PersonDetailsClient.swift
//  PersonDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import PeopleApplication

@DependencyClient
struct PersonDetailsClient: Sendable {

    var fetch: @Sendable (Int) async throws -> Person

}

extension PersonDetailsClient: DependencyKey {

    static var liveValue: PersonDetailsClient {
        @Dependency(\.fetchPersonDetails) var fetchPersonDetails

        return PersonDetailsClient(
            fetch: { id in
                let person = try await fetchPersonDetails.execute(id: id)
                let mapper = PersonMapper()
                return mapper.map(person)
            }
        )
    }

    static var previewValue: PersonDetailsClient {
        PersonDetailsClient(
            fetch: { _ in
                try await Task.sleep(for: .seconds(2))

                return Person(
                    id: 2283,
                    name: "Stanley Tucci",
                    biography:
                    "Stanley Tucci Stanley Tucci Stanley Tucci Stanley Tucci Stanley Tucci",
                    knownForDepartment: "Acting",
                    gender: .male,
                    profileURL: URL(
                        string: "https://image.tmdb.org/t/p/h632/q4TanMDI5Rgsvw4SfyNbPBh4URr.jpg")
                )
            }
        )
    }

}

extension DependencyValues {

    var personDetails: PersonDetailsClient {
        get {
            self[PersonDetailsClient.self]
        }
        set {
            self[PersonDetailsClient.self] = newValue
        }
    }

}
