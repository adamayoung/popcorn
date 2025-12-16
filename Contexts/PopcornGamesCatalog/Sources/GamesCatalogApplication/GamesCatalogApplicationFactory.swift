//
//  GamesCatalogApplicationFactory.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

package final class GamesCatalogApplicationFactory {

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
