//
//  FeatureFlagsAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FeatureFlags
import Foundation
import OSLog

public final class FeatureFlagsAdaptersFactory {

    public init() {}

    public func makeFeatureFlagsFactory() -> FeatureFlagsFactory {
        let provider = StatsigFeatureFlagProvider()
        return FeatureFlagsFactory(provider: provider)
    }

}
