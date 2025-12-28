//
//  PopcornGamesCatalogAdaptersFactory.swift
//  PopcornGamesCatalogAdapters
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation
import GamesCatalogComposition

///
/// A factory for creating games catalog-related adapters.
///
/// Creates adapters that bridge feature flag services to the games catalog domain.
///
public final class PopcornGamesCatalogAdaptersFactory {

    private let featureFlags: any FeatureFlagging

    ///
    /// Creates a games catalog adapters factory.
    ///
    /// - Parameter featureFlags: The feature flags service.
    ///
    public init(featureFlags: some FeatureFlagging) {
        self.featureFlags = featureFlags
    }

    ///
    /// Creates a games catalog factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornGamesCatalogFactory`` instance.
    ///
    public func makeGamesCatalogFactory() -> PopcornGamesCatalogFactory {
        let featureFlagProvider = FeatureFlagProvider(featureFlags: featureFlags)
        return PopcornGamesCatalogFactory(featureFlagProvider: featureFlagProvider)
    }

}
