//
//  FetchGameUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication

enum FetchGameUseCaseKey: DependencyKey {

    static var liveValue: any FetchGameUseCase {
        @Dependency(\.gamesCatalogFactory) var gamesCatalogFactory
        return gamesCatalogFactory.makeFetchGameUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for fetching a single game from the catalog.
    ///
    /// Retrieves detailed information about a specific game by its identifier.
    ///
    var fetchGame: any FetchGameUseCase {
        get { self[FetchGameUseCaseKey.self] }
        set { self[FetchGameUseCaseKey.self] = newValue }
    }

}
