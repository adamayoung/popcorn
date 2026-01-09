//
//  GamesCatalogFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import GamesCatalogComposition
import PopcornGamesCatalogAdapters

enum PopcornGamesCatalogFactoryKey: DependencyKey {

    static var liveValue: PopcornGamesCatalogFactory {
        @Dependency(\.featureFlags) var featureFlags
        return PopcornGamesCatalogAdaptersFactory(
            featureFlags: featureFlags
        ).makeGamesCatalogFactory()
    }

}

extension DependencyValues {

    var gamesCatalogFactory: PopcornGamesCatalogFactory {
        get { self[PopcornGamesCatalogFactoryKey.self] }
        set { self[PopcornGamesCatalogFactoryKey.self] = newValue }
    }

}
