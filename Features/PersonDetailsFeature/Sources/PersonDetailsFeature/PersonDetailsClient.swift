//
//  PersonDetailsClient.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import PeopleApplication

@DependencyClient
struct PersonDetailsClient: Sendable {

    var fetchPerson: @Sendable (Int) async throws -> Person
    var isFocalPointEnabled: @Sendable () throws -> Bool

}

extension PersonDetailsClient: DependencyKey {

    static var liveValue: PersonDetailsClient {
        @Dependency(\.fetchPersonDetails) var fetchPersonDetails
        @Dependency(\.featureFlags) var featureFlags

        return PersonDetailsClient(
            fetchPerson: { id in
                let person = try await fetchPersonDetails.execute(id: id)
                let mapper = PersonMapper()
                return mapper.map(person)
            },
            // Shares the backdropFocalPoint gate intentionally — focal point
            // alignment is a single feature covering both backdrop and profile images.
            isFocalPointEnabled: {
                featureFlags.isEnabled(.backdropFocalPoint)
            }
        )
    }

    static var previewValue: PersonDetailsClient {
        PersonDetailsClient(
            fetchPerson: { _ in
                Person.mock
            },
            isFocalPointEnabled: { true }
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
