//
//  FeatureFlags.swift
//  FeatureFlags
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation

public struct FeatureFlags: Sendable {

    private let provider: any FeatureFlagProviding

    public init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    public func isEnabled(_ key: some StringProtocol) -> Bool {
        provider.isEnabled(key.description)
    }

}
