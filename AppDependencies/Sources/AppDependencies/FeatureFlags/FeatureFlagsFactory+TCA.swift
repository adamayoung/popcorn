//
//  FeatureFlagsFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 16/12/2025.
//

import ComposableArchitecture
import FeatureFlags
import FeatureFlagsAdapters
import Foundation

extension DependencyValues {

    var featureFlagsFactory: FeatureFlagsFactory {
        FeatureFlagsAdaptersFactory().makeFeatureFlagsFactory()
    }

}
