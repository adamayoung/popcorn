//
//  FeatureFlagService.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

struct FeatureFlagService: FeatureFlagging, FeatureFlagOverriding, FeatureFlagInitialising {

    private static let logger = Logger.featureFlags

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
        userDefaults.set(value, forKey: flag.id)
    }

    func overrideValue(for flag: FeatureFlag) -> Bool? {
        guard userDefaults.object(forKey: flag.id) != nil else {
            return nil
        }

        return userDefaults.bool(forKey: flag.id)
    }

    func removeOverride(for flag: FeatureFlag) {
        userDefaults.removeObject(forKey: flag.id)
    }

}
