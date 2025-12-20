//
//  FeatureFlagsInitialiser+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureFlags
import Foundation

enum FeatureFlagsInitialiserKey: DependencyKey {

    static var liveValue: any FeatureFlagInitialising {
        @Dependency(\.featureFlagsFactory) var featureFlagsFactory
        return featureFlagsFactory.makeService()
    }

}

public extension DependencyValues {

    var featureFlagsInitialiser: any FeatureFlagInitialising {
        get { self[FeatureFlagsInitialiserKey.self] }
        set { self[FeatureFlagsInitialiserKey.self] = newValue }
    }

}
