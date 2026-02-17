//
//  FetchGameUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var fetchGame: any FetchGameUseCase {
        get { self[FetchGameUseCaseKey.self] }
        set { self[FetchGameUseCaseKey.self] = newValue }
    }

}
