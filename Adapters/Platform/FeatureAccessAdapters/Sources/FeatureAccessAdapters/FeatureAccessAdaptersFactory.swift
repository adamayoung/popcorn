//
//  FeatureAccessAdaptersFactory.swift
//  FeatureAccessAdapters
//
//  Copyright © 2026 Adam Young.
//

import FeatureAccess
import Foundation
import OSLog

public final class FeatureAccessAdaptersFactory {

    public init() {}

    public func makeFeatureFlagsFactory() -> FeatureFlagsFactory {
        let provider = StatsigFeatureFlagProvider()
        return FeatureFlagsFactory(provider: provider)
    }

}
