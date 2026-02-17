//
//  GamesCatalogInfrastructureFactory.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

package final class GamesCatalogInfrastructureFactory {

    private let featureFlagProvider: any FeatureFlagProviding

    package init(featureFlagProvider: some FeatureFlagProviding) {
        self.featureFlagProvider = featureFlagProvider
    }

    package func makeGameRepository() -> some GameRepository {
        DefaultGameRepository(featureFlagProvider: featureFlagProvider)
    }

}
