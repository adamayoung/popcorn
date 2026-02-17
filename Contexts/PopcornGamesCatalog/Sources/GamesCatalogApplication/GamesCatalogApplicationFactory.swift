//
//  GamesCatalogApplicationFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

public final class GamesCatalogApplicationFactory: Sendable {

    private let gameRepository: any GameRepository

    public init(gameRepository: some GameRepository) {
        self.gameRepository = gameRepository
    }

    public func makeFetchGamesUseCase() -> some FetchGamesUseCase {
        DefaultFetchGamesUseCase(repository: gameRepository)
    }

    public func makeFetchGameUseCase() -> some FetchGameUseCase {
        DefaultFetchGameUseCase(repository: gameRepository)
    }

}
