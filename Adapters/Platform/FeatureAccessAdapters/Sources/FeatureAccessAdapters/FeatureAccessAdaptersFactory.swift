//
//  FeatureAccessAdaptersFactory.swift
//  FeatureAccessAdapters
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation
import OSLog

///
/// A factory for creating feature access-related adapters.
///
/// Creates adapters that bridge feature flag providers to the application's
/// feature access layer.
///
public final class FeatureAccessAdaptersFactory {

    /// Creates a feature access adapters factory.
    public init() {}

    ///
    /// Creates a feature flags factory with configured adapters.
    ///
    /// - Returns: A configured ``FeatureFlagsFactory`` instance.
    ///
    public func makeFeatureFlagsFactory() -> FeatureFlagsFactory {
        let provider = StatsigFeatureFlagProvider()
        return FeatureFlagsFactory(provider: provider)
    }

}
