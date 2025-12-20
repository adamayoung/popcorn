//
//  FeatureFlags+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureFlags
import Foundation

enum FeatureFlagsKey: DependencyKey {

    static var liveValue: any FeatureFlagging {
        @Dependency(\.featureFlagsFactory) var featureFlagsFactory
        return featureFlagsFactory.makeService()
    }

}

public extension DependencyValues {

    var featureFlags: any FeatureFlagging {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }

}
