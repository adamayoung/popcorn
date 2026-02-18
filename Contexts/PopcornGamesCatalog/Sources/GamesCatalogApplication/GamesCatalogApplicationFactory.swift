//
//  GamesCatalogApplicationFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

package final class GamesCatalogApplicationFactory: Sendable {

    private let gameRepository: any GameRepository

    package init(gameRepository: some GameRepository) {
        self.gameRepository = gameRepository
    }

    package func makeFetchGamesUseCase() -> some FetchGamesUseCase {
        DefaultFetchGamesUseCase(repository: gameRepository)
    }

    package func makeFetchGameUseCase() -> some FetchGameUseCase {
        DefaultFetchGameUseCase(repository: gameRepository)
    }

}
