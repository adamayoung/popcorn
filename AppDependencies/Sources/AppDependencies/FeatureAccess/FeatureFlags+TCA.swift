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
        return featureAccessFactory.makeService()
    }

}

public extension DependencyValues {

    ///
    /// A service for querying feature flag states.
    ///
    /// Provides access to feature flags for enabling or disabling features
    /// based on configuration or remote settings.
    ///
    var featureFlags: any FeatureFlagging {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }

}
