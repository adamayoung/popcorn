//
//  FetchGamesUseCase+TCA.swift
//  PopcornGamesCatalogAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication

enum FetchGamesUseCaseKey: DependencyKey {

    static var liveValue: any FetchGamesUseCase {
        DependencyValues._current
            .gamesCatalogFactory
            .makeFetchGamesUseCase()
    }

}

extension DependencyValues {

    public var fetchGames: any FetchGamesUseCase {
        get { self[FetchGamesUseCaseKey.self] }
        set { self[FetchGamesUseCaseKey.self] = newValue }
    }

}
