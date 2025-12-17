//
//  FeatureFlagsInitialiser+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 16/12/2025.
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

extension DependencyValues {

    public var featureFlagsInitialiser: any FeatureFlagInitialising {
        get { self[FeatureFlagsInitialiserKey.self] }
        set { self[FeatureFlagsInitialiserKey.self] = newValue }
    }

}
