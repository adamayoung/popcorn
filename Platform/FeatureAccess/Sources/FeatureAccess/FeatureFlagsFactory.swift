//
//  FeatureFlagsFactory.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A factory for creating feature flag service instances.
///
/// Use this factory to create configured feature flag services with a specific
/// provider implementation.
///
public final class FeatureFlagsFactory {

    private let provider: any FeatureFlagProviding

    ///
    /// Creates a new feature flags factory with the specified provider.
    ///
    /// - Parameter provider: The feature flag provider implementation.
    ///
    public init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    ///
    /// Creates a new feature flag service instance.
    ///
    /// - Returns: A service conforming to both ``FeatureFlagging`` and
    ///   ``FeatureFlagInitialising``.
    ///
    public func makeService() -> some FeatureFlagging & FeatureFlagInitialising {
        FeatureFlagService(provider: provider)
    }

}
