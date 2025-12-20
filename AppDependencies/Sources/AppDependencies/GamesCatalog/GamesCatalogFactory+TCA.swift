//
//  GamesCatalogFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GamesCatalogComposition
import PopcornGamesCatalogAdapters

extension DependencyValues {

    var gamesCatalogFactory: PopcornGamesCatalogFactory {
        @Dependency(\.featureFlags) var featureFlags
        return PopcornGamesCatalogAdaptersFactory(
            featureFlags: featureFlags
        ).makeGamesCatalogFactory()
    }

}
