//
//  FeatureAccessFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import FeatureAccess
import FeatureAccessAdapters
import Foundation

enum FeatureAccessFactoryKey: DependencyKey {

    static var liveValue: FeatureFlagsFactory {
        FeatureAccessAdaptersFactory().makeFeatureFlagsFactory()
    }

}

extension DependencyValues {

    var featureAccessFactory: FeatureFlagsFactory {
        get { self[FeatureAccessFactoryKey.self] }
        set { self[FeatureAccessFactoryKey.self] = newValue }
    }

}
