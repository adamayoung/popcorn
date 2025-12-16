//
//  FeatureFlagService.swift
//  FeatureFlags
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation

struct FeatureFlagService: FeatureFlags, FeatureFlagInitialising {

    private let provider: any FeatureFlagProviding

    init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    func start(_ config: FeatureFlagsConfiguration) async throws {
        try await provider.start(config)
    }

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        provider.isEnabled(flag.rawValue)
    }

    func isEnabled(_ key: some StringProtocol) -> Bool {
        provider.isEnabled(key.description)
    }

}
