//
//  GamesCatalogDependencies.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``GamesCatalogViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``GamesCatalogViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct GamesCatalogDependencies: Sendable {

    public var fetchGames: @Sendable () async throws -> [GameMetadata]

    public init(
        fetchGames: @escaping @Sendable () async throws -> [GameMetadata]
    ) {
        self.fetchGames = fetchGames
    }

}

#if DEBUG
    public extension GamesCatalogDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: GamesCatalogDependencies {
            GamesCatalogDependencies(
                fetchGames: { GameMetadata.mocks }
            )
        }

    }
#endif
