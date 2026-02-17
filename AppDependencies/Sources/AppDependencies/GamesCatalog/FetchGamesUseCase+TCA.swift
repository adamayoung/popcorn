//
//  FetchGamesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var fetchGames: any FetchGamesUseCase {
        get { self[FetchGamesUseCaseKey.self] }
        set { self[FetchGamesUseCaseKey.self] = newValue }
    }

}
