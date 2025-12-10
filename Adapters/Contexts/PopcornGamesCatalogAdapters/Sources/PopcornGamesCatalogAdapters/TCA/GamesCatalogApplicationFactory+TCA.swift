//
//  GamesCatalogApplicationFactory+TCA.swift
//  PopcornGamesCatalogAdapters
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogApplication

extension DependencyValues {

    var gamesCatalogFactory: GamesCatalogApplicationFactory {
        PopcornGamesCatalogAdaptersFactory().makeGamesCatalogFactory()
    }

}
