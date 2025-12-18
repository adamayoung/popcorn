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

    private let featureFlags: any FeatureFlagging

    init(featureFlags: some FeatureFlagging) {
        self.featureFlags = featureFlags
    }

    func isEmojiPlotDecoderEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.emojiPlotDecoderGame)
    }

    func isPlotRemixGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.plotRemixGame)
    }

    func isPosterPixelationGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.posterPixelationGame)
    }

    func isTimelineTangleGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.timelineTangleGame)
    }

}
