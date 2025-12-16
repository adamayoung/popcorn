//
//  FetchGameUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 09/12/2025.
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

extension DependencyValues {

    public var fetchGame: any FetchGameUseCase {
        get { self[FetchGameUseCaseKey.self] }
        set { self[FetchGameUseCaseKey.self] = newValue }
    }

}
