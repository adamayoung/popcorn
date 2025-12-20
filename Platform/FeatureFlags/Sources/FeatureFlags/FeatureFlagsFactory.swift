//
//  FeatureFlagsFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public final class FeatureFlagsFactory {

    private let provider: any FeatureFlagProviding

    public init(provider: some FeatureFlagProviding) {
        self.provider = provider
    }

    public func makeService() -> some FeatureFlagging & FeatureFlagInitialising {
        FeatureFlagService(provider: provider)
    }

}
