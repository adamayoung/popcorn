//
//  PopcornGamesCatalogFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogApplication
import GamesCatalogDomain
import GamesCatalogInfrastructure

public final class PopcornGamesCatalogFactory: Sendable {

    private let applicationFactory: GamesCatalogApplicationFactory

    public init(featureFlagProvider: some FeatureFlagProviding) {
        let infrastructureFactory = GamesCatalogInfrastructureFactory(
            featureFlagProvider: featureFlagProvider
        )
        self.applicationFactory = GamesCatalogApplicationFactory(
            gameRepository: infrastructureFactory.makeGameRepository()
        )
    }

    public func makeFetchGamesUseCase() -> FetchGamesUseCase {
        applicationFactory.makeFetchGamesUseCase()
    }

    public func makeFetchGameUseCase() -> FetchGameUseCase {
        applicationFactory.makeFetchGameUseCase()
    }

}
