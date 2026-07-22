//
//  PersonCreditsDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``PersonCreditsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``PersonCreditsViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct PersonCreditsDependencies: Sendable {

    public var fetchCredits: @Sendable (_ personID: Int) async throws -> [CreditItem]

    public init(
        fetchCredits: @escaping @Sendable (_ personID: Int) async throws -> [CreditItem]
    ) {
        self.fetchCredits = fetchCredits
    }

}

#if DEBUG
    public extension PersonCreditsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: PersonCreditsDependencies {
            PersonCreditsDependencies(
                fetchCredits: { _ in CreditItem.mocks }
            )
        }

    }
#endif
