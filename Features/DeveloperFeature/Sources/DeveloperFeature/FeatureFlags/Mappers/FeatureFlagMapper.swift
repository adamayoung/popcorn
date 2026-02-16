//
//  FeatureFlagMapper.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import FeatureAccess
import Foundation

struct FeatureFlagMapper {

    func map(_ model: FeatureAccess.FeatureFlag, value: Bool, overrideValue: Bool?) -> FeatureFlag {
        FeatureFlag(
            id: model.id,
            name: model.name,
            description: model.description,
            value: value,
            override: FeatureFlagOverrideState(value: overrideValue)
        )
    }

}
