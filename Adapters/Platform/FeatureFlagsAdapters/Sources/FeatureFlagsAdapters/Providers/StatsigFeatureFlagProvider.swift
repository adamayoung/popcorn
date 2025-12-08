//
//  StatsigFeatureFlagProvider.swift
//  FeatureFlagsAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import FeatureFlags
import Foundation
import Statsig

public struct StatsigFeatureFlagProvider: FeatureFlagProviding {

    public init() {}

    public func isEnabled(_ key: String) -> Bool {
        Statsig.checkGate(key)
    }
}
