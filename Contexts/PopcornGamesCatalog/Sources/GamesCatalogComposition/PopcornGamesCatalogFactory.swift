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

///
/// The main factory for creating games catalog use cases.
///
/// This factory serves as the composition root for the PopcornGamesCatalog module,
/// assembling all the required dependencies and providing access to the available
/// use cases for interacting with the games catalog.
///
public final class PopcornGamesCatalogFactory {

    private let applicationFactory: GamesCatalogApplicationFactory

    ///
    /// Creates a new games catalog factory.
    ///
    /// - Parameter featureFlagProvider: The feature flag provider used to determine
    ///   which games are enabled in the catalog.
    ///
    public init(featureFlagProvider: some FeatureFlagProviding) {
        let infrastructureFactory = GamesCatalogInfrastructureFactory(
            featureFlagProvider: featureFlagProvider
        )
        self.applicationFactory = GamesCatalogApplicationFactory(
            gameRepository: infrastructureFactory.makeGameRepository()
        )
    }

    ///
    /// Creates a use case for fetching all available games.
    ///
    /// - Returns: A ``FetchGamesUseCase`` instance for retrieving the games list.
    ///
    public func makeFetchGamesUseCase() -> some FetchGamesUseCase {
        applicationFactory.makeFetchGamesUseCase()
    }

    ///
    /// Creates a use case for fetching a single game by identifier.
    ///
    /// - Returns: A ``FetchGameUseCase`` instance for retrieving individual games.
    ///
    public func makeFetchGameUseCase() -> some FetchGameUseCase {
        applicationFactory.makeFetchGameUseCase()
    }

}
