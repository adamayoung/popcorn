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

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        if let overrideValue = overrideValue(for: flag) {
            return overrideValue
        }

        return actualValue(for: flag)
    }

}

extension FeatureFlagService {

    func actualValue(for flag: FeatureFlag) -> Bool {
        featureFlagProvider.isEnabled(flag.id)
    }

    func setOverrideValue(_ value: Bool, for flag: FeatureFlag) {
        userDefaults.set(value, forKey: overrideKey(for: flag))
    }

    func overrideValue(for flag: FeatureFlag) -> Bool? {
        let key = overrideKey(for: flag)
        guard userDefaults.object(forKey: key) != nil else {
            return nil
        }

        return userDefaults.bool(forKey: key)
    }

    func removeOverride(for flag: FeatureFlag) {
        userDefaults.removeObject(forKey: overrideKey(for: flag))
    }

    private func overrideKey(for flag: FeatureFlag) -> String {
        Self.overrideKeyPrefix + flag.id
    }

}
