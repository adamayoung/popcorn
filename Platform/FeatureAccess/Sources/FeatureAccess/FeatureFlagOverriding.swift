//
//  FeatureFlagOverriding.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

public protocol FeatureFlagOverriding: Sendable {

    func actualValue(for featureFlag: FeatureFlag) -> Bool

    func setOverrideValue(_ value: Bool, for featureFlag: FeatureFlag)

    func overrideValue(for featureFlag: FeatureFlag) -> Bool?

    func removeOverride(for featureFlag: FeatureFlag)

    func removeAllOverrides()

}
