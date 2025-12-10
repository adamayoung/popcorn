//
//  FetchGameUseCase+TCA.swift
//  PopcornGamesCatalogAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication

enum FetchGameUseCaseKey: DependencyKey {

    static var liveValue: any FetchGameUseCase {
        DependencyValues._current
            .gamesCatalogFactory
            .makeFetchGameUseCase()
    }

}

extension DependencyValues {

    public var fetchGame: any FetchGameUseCase {
        get { self[FetchGameUseCaseKey.self] }
        set { self[FetchGameUseCaseKey.self] = newValue }
    }

}
