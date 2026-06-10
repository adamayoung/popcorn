//
//  PopcornGamesCatalogAdaptersFactory.swift
//  PopcornGamesCatalogAdapters
//
//  Copyright © 2026 Adam Young.
//

import FeatureAccess
import GamesCatalogDomain

public final class PopcornGamesCatalogAdaptersFactory {

    private let featureFlags: any FeatureFlagging

    public init(featureFlags: some FeatureFlagging) {
        self.featureFlags = featureFlags
    }

    public func makeFeatureFlagProvider() -> some GamesCatalogDomain.FeatureFlagProviding {
        FeatureFlagProvider(featureFlags: featureFlags)
    }

}
