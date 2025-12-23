//
//  FeatureAccessFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import FeatureAccess
import FeatureAccessAdapters
import Foundation

extension DependencyValues {

    var featureAccessFactory: FeatureFlagsFactory {
        FeatureAccessAdaptersFactory().makeFeatureFlagsFactory()
    }

}
