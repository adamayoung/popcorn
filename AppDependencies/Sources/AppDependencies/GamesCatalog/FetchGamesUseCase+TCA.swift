//
//  FetchGamesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication

enum FetchGamesUseCaseKey: DependencyKey {

    static var liveValue: any FetchGamesUseCase {
        @Dependency(\.gamesCatalogFactory) var gamesCatalogFactory
        return gamesCatalogFactory.makeFetchGamesUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for fetching a list of games from the catalog.
    ///
    /// Retrieves all available games in the application's game catalog.
    ///
    var fetchGames: any FetchGamesUseCase {
        get { self[FetchGamesUseCaseKey.self] }
        set { self[FetchGamesUseCaseKey.self] = newValue }
    }

}
