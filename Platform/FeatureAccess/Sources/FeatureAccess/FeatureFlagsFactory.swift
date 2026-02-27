//
//  FeatureFlagsFactory.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public final class FeatureFlagsFactory: Sendable {

    public let featureFlagService: any FeatureFlagging & FeatureFlagOverriding & FeatureFlagInitialising

    public init(provider: some FeatureFlagProviding) {
        self.featureFlagService = FeatureFlagService(featureFlagProvider: provider, userDefaults: .standard)
    }

}
