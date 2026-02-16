//
//  FeatureFlagOverriding.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

public protocol FeatureFlagOverriding: Sendable {

    func actualValue(for flag: FeatureFlag) -> Bool

    func setOverrideValue(_ value: Bool, for flag: FeatureFlag)

    func overrideValue(for flag: FeatureFlag) -> Bool?

    func removeOverride(for flag: FeatureFlag)

}
