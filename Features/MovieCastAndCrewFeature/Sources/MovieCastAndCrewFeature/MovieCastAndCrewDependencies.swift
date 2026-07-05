//
//  MovieCastAndCrewDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``MovieCastAndCrewViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``MovieCastAndCrewViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct MovieCastAndCrewDependencies: Sendable {

    public var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits

    public init(
        fetchCredits: @escaping @Sendable (_ movieID: Int) async throws -> Credits
    ) {
        self.fetchCredits = fetchCredits
    }

}

#if DEBUG
    public extension MovieCastAndCrewDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: MovieCastAndCrewDependencies {
            MovieCastAndCrewDependencies(
                fetchCredits: { _ in Credits.mock }
            )
        }

    }
#endif
