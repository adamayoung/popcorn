//
//  PopcornGamesCatalogFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogApplication
import GamesCatalogDomain
import GamesCatalogInfrastructure

public final class PopcornGamesCatalogFactory {

    private let applicationFactory: GamesCatalogApplicationFactory

    public init(featureFlagProvider: some FeatureFlagProviding) {
        let infrastructureFactory = GamesCatalogInfrastructureFactory(
            featureFlagProvider: featureFlagProvider
        )
        self.applicationFactory = GamesCatalogApplicationFactory(
            gameRepository: infrastructureFactory.makeGameRepository()
        )
    }

    public func makeFetchGamesUseCase() -> some FetchGamesUseCase {
        applicationFactory.makeFetchGamesUseCase()
    }

    public func makeFetchGameUseCase() -> some FetchGameUseCase {
        applicationFactory.makeFetchGameUseCase()
    }

}
