//
//  GamesCatalogInfrastructureFactory.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
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
