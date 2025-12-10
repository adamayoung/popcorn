//
//  GamesCatalogClientFactory.swift
//  GamesCatalogFeature
//
//  Created by Adam Young on 04/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication
import PopcornGamesCatalogAdapters

struct GamesCatalogClientFactory {

    @Dependency(\.fetchGames) private var fetchGames: FetchGamesUseCase

    func makeFetchGames() -> FetchGamesUseCase {
        self.fetchGames
    }

}
