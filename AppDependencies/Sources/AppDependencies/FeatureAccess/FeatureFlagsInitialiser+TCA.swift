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
        return featureAccessFactory.makeFeatureFlagService()
    }

}

public extension DependencyValues {

    var featureFlagsInitialiser: any FeatureFlagInitialising {
        get { self[FeatureFlagsInitialiserKey.self] }
        set { self[FeatureFlagsInitialiserKey.self] = newValue }
    }

}
