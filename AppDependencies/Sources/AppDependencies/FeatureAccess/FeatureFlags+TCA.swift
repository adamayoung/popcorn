//
//  FeatureFlags+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureAccess
import Foundation

enum FeatureFlagsKey: DependencyKey {

    static var liveValue: any FeatureFlagging {
        @Dependency(\.featureAccessFactory) var featureAccessFactory
        return featureAccessFactory.makeFeatureFlagService()
    }

}

public extension DependencyValues {

    var featureFlags: any FeatureFlagging {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }

}
