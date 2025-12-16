//
//  GamesCatalogInfrastructureFactory.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

package final class GamesCatalogInfrastructureFactory {

    package init() {}

    package func makeGameRepository() -> some GameRepository {
        DefaultGameRepository()
    }

}
