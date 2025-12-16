//
//  FeatureFlagsAdaptersFactory.swift
//  FeatureFlagsAdapters
//
//  Created by Adam Young on 16/12/2025.
//

import FeatureFlags
import Foundation
import OSLog

public final class FeatureFlagsAdaptersFactory {

    private static let logger = Logger(
        subsystem: "FeatureFlagsAdapters",
        category: "FeatureFlagsAdaptersFactory"
    )

    public init() {}

    public func makeFeatureFlagsFactory() -> FeatureFlagsFactory {
        let provider = StatsigFeatureFlagProvider()
        return FeatureFlagsFactory(provider: provider)
    }

}
