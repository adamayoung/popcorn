//
//  FeatureFlagsFactory.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public final class FeatureFlagsFactory {

    private let provider: any FeatureFlagProviding

    public init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    public func makeFeatureFlagService() -> some FeatureFlagging & FeatureFlagOverriding & FeatureFlagInitialising {
        FeatureFlagService(featureFlagProvider: provider, userDefaults: .standard)
    }

}
