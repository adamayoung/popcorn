//
//  FeatureFlagProvider.swift
//  PopcornGamesCatalogAdapters
//
//  Created by Adam Young on 16/12/2025.
//

import FeatureFlags
import Foundation
import GamesCatalogDomain

final class FeatureFlagProvider: GamesCatalogDomain.FeatureFlagProviding {

    private let featureFlags: any FeatureFlags

    init(featureFlags: some FeatureFlags) {
        self.featureFlags = featureFlags
    }

    func isEmojiPlotDecoderEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.emojiPlotDecoderGame)
    }

}
