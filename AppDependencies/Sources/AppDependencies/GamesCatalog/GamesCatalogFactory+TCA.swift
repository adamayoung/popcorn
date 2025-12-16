//
//  GamesCatalogApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogComposition
import PopcornGamesCatalogAdapters

extension DependencyValues {

    var gamesCatalogFactory: PopcornGamesCatalogFactory {
        PopcornGamesCatalogAdaptersFactory().makeGamesCatalogFactory()
    }

}
