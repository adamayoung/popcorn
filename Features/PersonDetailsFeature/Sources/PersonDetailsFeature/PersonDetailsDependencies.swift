//
//  PersonDetailsDependencies.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication

/// The dependencies required by ``PersonDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``PersonDetailsViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
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

#if DEBUG
    public extension PersonDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: PersonDetailsDependencies {
            PersonDetailsDependencies(
                fetchPerson: { _ in Person.mock },
                isFocalPointEnabled: { true }
            )
        }

    }
#endif
