//
//  FeatureFlagsFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
