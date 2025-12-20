//
//  FeatureFlagsFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureAccess
import FeatureAccessAdapters
import Foundation

extension DependencyValues {

    var featureFlagsFactory: FeatureFlagsFactory {
        FeatureAccessAdaptersFactory().makeFeatureFlagsFactory()
    }

}
