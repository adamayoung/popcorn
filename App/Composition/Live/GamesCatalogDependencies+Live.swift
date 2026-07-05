//
//  GamesCatalogDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import GamesCatalogApplication
import GamesCatalogComposition
import GamesCatalogFeature

extension GamesCatalogDependencies {

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
