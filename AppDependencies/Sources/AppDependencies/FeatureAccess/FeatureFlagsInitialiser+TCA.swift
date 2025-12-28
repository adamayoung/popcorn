//
//  FeatureFlagsInitialiser+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureAccess
import Foundation

enum FeatureFlagsInitialiserKey: DependencyKey {

    static var liveValue: any FeatureFlagInitialising {
        @Dependency(\.featureAccessFactory) var featureAccessFactory
        return featureAccessFactory.makeService()
    }

}

public extension DependencyValues {

    ///
    /// A service for initialising the feature flags infrastructure.
    ///
    /// Configures and starts the feature flag system with the appropriate
    /// settings for the current environment.
    ///
    var featureFlagsInitialiser: any FeatureFlagInitialising {
        get { self[FeatureFlagsInitialiserKey.self] }
        set { self[FeatureFlagsInitialiserKey.self] = newValue }
    }

}
