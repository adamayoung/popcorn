//
//  PersonDetailsDependencies.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import PeopleApplication

/// The dependencies required by ``PersonDetailsViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `PersonDetailsClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
public struct PersonDetailsDependencies: Sendable {

    public var fetchPerson: @Sendable (_ id: Int) async throws -> Person

    public var isFocalPointEnabled: @Sendable () throws -> Bool

    public init(
        fetchPerson: @escaping @Sendable (_ id: Int) async throws -> Person,
        isFocalPointEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchPerson = fetchPerson
        self.isFocalPointEnabled = isFocalPointEnabled
    }

}

public extension PersonDetailsDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `PersonDetailsClient.liveValue` exactly: same use case,
    /// same mapper, same feature flag.
    static func live(services: AppServices) -> PersonDetailsDependencies {
        let fetchPersonDetails = services.peopleFactory.makeFetchPersonDetailsUseCase()
        let featureFlags = services.featureFlags

        return PersonDetailsDependencies(
            fetchPerson: { id in
                do {
                    let person = try await fetchPersonDetails.execute(id: id)
                    let mapper = PersonMapper()
                    return mapper.map(person)
                } catch let error as FetchPersonDetailsError {
                    throw FetchPersonError(error)
                }
            },
            // Shares the backdropFocalPoint gate intentionally — focal point
            // alignment is a single feature covering both backdrop and profile images.
            isFocalPointEnabled: {
                featureFlags.isEnabled(.backdropFocalPoint)
            }
        )
    }

}

#if DEBUG
    public extension PersonDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `PersonDetailsClient.previewValue`).
        static var preview: PersonDetailsDependencies {
            PersonDetailsDependencies(
                fetchPerson: { _ in Person.mock },
                isFocalPointEnabled: { true }
            )
        }

    }
#endif
