//
//  GamesCatalogComposition.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain
import GamesCatalogInfrastructure

public struct GamesCatalogComposition {

    private init() {}

    public static func makeGamesCatalogFactory() -> GamesCatalogApplicationFactory {
        let infrastructureFactory = GamesCatalogInfrastructureFactory()
        let gameRepository = infrastructureFactory.makeGameRepository()

        return GamesCatalogApplicationFactory(gameRepository: gameRepository)
    }

}
