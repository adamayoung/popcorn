//
//  GamesCatalogDependencies.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import GamesCatalogApplication

/// The dependencies required by ``GamesCatalogViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``GamesCatalogViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. Build the production instance with
/// ``live(services:)``.
public struct GamesCatalogDependencies: Sendable {

    public var fetchGames: @Sendable () async throws -> [GameMetadata]

    public init(
        fetchGames: @escaping @Sendable () async throws -> [GameMetadata]
    ) {
        self.fetchGames = fetchGames
    }

}

public extension GamesCatalogDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Uses the fetch-games use case with its mapper and translates domain errors to
    /// ``FetchGamesCatalogError``.
    static func live(services: AppServices) -> GamesCatalogDependencies {
        let fetchGames = services.gamesCatalogFactory.makeFetchGamesUseCase()

        return GamesCatalogDependencies(
            fetchGames: {
                do {
                    let games = try await fetchGames.execute()
                    let mapper = GameMetadataMapper()
                    return games.map(mapper.map)
                } catch let error as FetchGamesError {
                    throw FetchGamesCatalogError(error)
                }
            }
        )
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
