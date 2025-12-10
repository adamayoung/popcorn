//
//  GamesCatalogApplicationFactory.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

public final class GamesCatalogApplicationFactory {

    private let gameRepository: any GameRepository

    init(gameRepository: some GameRepository) {
        self.gameRepository = gameRepository
    }

    public func makeFetchGamesUseCase() -> some FetchGamesUseCase {
        DefaultFetchGamesUseCase(repository: gameRepository)
    }

    public func makeFetchGameUseCase() -> some FetchGameUseCase {
        DefaultFetchGameUseCase(repository: gameRepository)
    }

}
