//
//  FeatureFlags+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 26/11/2025.
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

extension DependencyValues {

    public var featureFlags: any FeatureFlagging {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }

}
