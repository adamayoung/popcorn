//
//  UITestPopcornGamesCatalogFactory.swift
//  PopcornGamesCatalogAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogApplication
import GamesCatalogComposition
import GamesCatalogDomain

public final class UITestPopcornGamesCatalogFactory: PopcornGamesCatalogFactory {

    private let applicationFactory: GamesCatalogApplicationFactory

    public init() {
        self.applicationFactory = GamesCatalogApplicationFactory(
            gameRepository: StubGameRepository()
        )
    }

    public func makeFetchGamesUseCase() -> FetchGamesUseCase {
        applicationFactory.makeFetchGamesUseCase()
    }

    public func makeFetchGameUseCase() -> FetchGameUseCase {
        applicationFactory.makeFetchGameUseCase()
    }

}
