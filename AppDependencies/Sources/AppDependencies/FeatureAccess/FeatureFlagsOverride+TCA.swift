//
//  FeatureFlagsOverride+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureAccess
import Foundation

enum FeatureFlagsOverrideKey: DependencyKey {

    static var liveValue: any FeatureFlagging & FeatureFlagOverriding {
        @Dependency(\.featureAccessFactory) var featureAccessFactory
        return featureAccessFactory.makeFeatureFlagService()
    }

}

public extension DependencyValues {

    var featureFlagsOverride: any FeatureFlagging & FeatureFlagOverriding {
        get { self[FeatureFlagsOverrideKey.self] }
        set { self[FeatureFlagsOverrideKey.self] = newValue }
    }

}
