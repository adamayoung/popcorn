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

    var fetchPerson: @Sendable (Int) async throws -> Person

}

extension PersonDetailsClient: DependencyKey {

    static var liveValue: PersonDetailsClient {
        @Dependency(\.fetchPersonDetails) var fetchPersonDetails

        return PersonDetailsClient(
            fetchPerson: { id in
                let person = try await fetchPersonDetails.execute(id: id)
                let mapper = PersonMapper()
                return mapper.map(person)
            }
        )
    }

    static var previewValue: PersonDetailsClient {
        PersonDetailsClient(
            fetchPerson: { _ in
                Person.mock
            }
        )
    }

}

extension DependencyValues {

    var personDetailsClient: PersonDetailsClient {
        get {
            self[PersonDetailsClient.self]
        }
        set {
            self[PersonDetailsClient.self] = newValue
        }
    }

}
