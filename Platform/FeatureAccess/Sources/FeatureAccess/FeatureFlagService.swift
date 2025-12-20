//
//  FeatureFlagService.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import OSLog

struct FeatureFlagService: FeatureFlagging, FeatureFlagInitialising {

    private static let logger = Logger.featureFlags

    var isInitialised: Bool {
        provider.isInitialized
    }

    private let provider: any FeatureFlagProviding

    init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    func start(_ config: FeatureFlagsConfiguration) async throws {
        try await provider.start(config)

        var flagStatuses: [String] = []
        for featureFlag in FeatureFlag.allCases {
            let value = isEnabled(featureFlag)
            flagStatuses.append("\(featureFlag.rawValue): \(value)")
        }
        flagStatuses.sort()

        Self.logger.info(
            "Feature flags\n-------------\n\(flagStatuses.joined(separator: "\n"), privacy: .public)"
        )
    }

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        provider.isEnabled(flag.rawValue)
    }

    func isEnabled(_ key: some StringProtocol) -> Bool {
        provider.isEnabled(key.description)
    }

}
