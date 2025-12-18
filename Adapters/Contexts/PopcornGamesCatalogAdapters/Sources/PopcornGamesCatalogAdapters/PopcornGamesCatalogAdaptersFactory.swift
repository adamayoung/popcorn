//
//  PopcornGamesCatalogAdaptersFactory.swift
//  PopcornGamesCatalogAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import FeatureFlags
import Foundation
import GamesCatalogComposition

public final class PopcornGamesCatalogAdaptersFactory {

    private let featureFlags: any FeatureFlagging

    public init(featureFlags: some FeatureFlagging) {
        self.featureFlags = featureFlags
    }

    public func makeGamesCatalogFactory() -> PopcornGamesCatalogFactory {
        let featureFlagProvider = FeatureFlagProvider(featureFlags: featureFlags)
        return PopcornGamesCatalogFactory(featureFlagProvider: featureFlagProvider)
    }

}
