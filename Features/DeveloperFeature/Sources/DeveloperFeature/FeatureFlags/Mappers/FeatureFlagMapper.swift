//
//  FeatureFlagMapper.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import FeatureAccess
import Foundation

/// Maps a `FeatureAccess.FeatureFlag` to the feature's ``FeatureFlag`` presentation model.
public struct FeatureFlagMapper {

    /// Creates a feature-flag mapper.
    public init() {}

    /// Maps a `FeatureAccess.FeatureFlag` (with its actual and override values) to a
    /// presentation ``FeatureFlag``.
    public func map(_ model: FeatureAccess.FeatureFlag, value: Bool, overrideValue: Bool?) -> FeatureFlag {
        FeatureFlag(
            id: model.id,
            name: model.name,
            description: model.description,
            value: value,
            override: FeatureFlagOverrideState(value: overrideValue)
        )
    }

}
