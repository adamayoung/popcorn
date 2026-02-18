//
//  FeatureFlagService.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog

struct FeatureFlagService: FeatureFlagging, FeatureFlagOverriding, FeatureFlagInitialising {

    private static let logger = Logger.featureFlags
    private static let overrideKeyPrefix = "featureFlagOverride."

    var isInitialised: Bool {
        featureFlagProvider.isInitialized
    }

    private let featureFlagProvider: any FeatureFlagProviding
    private nonisolated(unsafe) let userDefaults: UserDefaults

    init(
        featureFlagProvider: some FeatureFlagProviding,
        userDefaults: UserDefaults
    ) {
        self.featureFlagProvider = featureFlagProvider
        self.userDefaults = userDefaults
    }
}

extension FeatureFlagService {

    func start(_ config: FeatureFlagsConfiguration) async throws {
        try await featureFlagProvider.start(config)

        var flagStatuses: [String] = []
        for flag in FeatureFlag.allFlags {
            let value = featureFlagProvider.isEnabled(flag.id)
            let overrideValue = overrideValue(for: flag)
            flagStatuses.append("\(flag.id): \(overrideValue ?? value)\(overrideValue != nil ? " (overridden)" : "")")
        }
        flagStatuses.sort()

        Self.logger.info(
            "Feature flags\n-------------\n\(flagStatuses.joined(separator: "\n"), privacy: .public)"
        )
    }

}

extension FeatureFlagService {

    func isEnabled(_ featureFlag: FeatureFlag) -> Bool {
        if let overrideValue = overrideValue(for: featureFlag) {
            return overrideValue
        }

        return actualValue(for: featureFlag)
    }

}

extension FeatureFlagService {

    func actualValue(for featureFlag: FeatureFlag) -> Bool {
        featureFlagProvider.isEnabled(featureFlag.id)
    }

    func setOverrideValue(_ value: Bool, for featureFlag: FeatureFlag) {
        userDefaults.set(value, forKey: overrideKey(for: featureFlag))
    }

    func overrideValue(for featureFlag: FeatureFlag) -> Bool? {
        let key = overrideKey(for: featureFlag)
        guard userDefaults.object(forKey: key) != nil else {
            return nil
        }

        return userDefaults.bool(forKey: key)
    }

    func removeOverride(for featureFlag: FeatureFlag) {
        userDefaults.removeObject(forKey: overrideKey(for: featureFlag))
    }

    func removeAllOverrides() {
        for featureFlag in FeatureFlag.allFlags {
            removeOverride(for: featureFlag)
        }
    }

    private func overrideKey(for flag: FeatureFlag) -> String {
        Self.overrideKeyPrefix + flag.id
    }

}
