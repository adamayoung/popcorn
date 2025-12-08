//
//  FeatureFlags+TCA.swift
//  FeatureFlagsAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import ComposableArchitecture
import FeatureFlags
import Foundation

enum FeatureFlagsKey: DependencyKey {

    static var liveValue: FeatureFlags {
        let provider = StatsigFeatureFlagProvider()
        return FeatureFlags(provider: provider)
    }

}

extension DependencyValues {

    public var featureFlags: FeatureFlags {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }

}
