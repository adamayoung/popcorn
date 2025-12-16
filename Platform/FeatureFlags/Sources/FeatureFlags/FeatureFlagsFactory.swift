//
//  FeatureFlagsFactory.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public final class FeatureFlagsFactory {

    private let provider: any FeatureFlagProviding

    public init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    public func makeService() -> some FeatureFlags & FeatureFlagInitialising {
        FeatureFlagService(provider: provider)
    }

}
