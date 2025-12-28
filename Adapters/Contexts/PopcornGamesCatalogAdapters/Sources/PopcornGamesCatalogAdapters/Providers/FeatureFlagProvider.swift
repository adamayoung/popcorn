//
//  FeatureFlagProvider.swift
//  PopcornGamesCatalogAdapters
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import Foundation
import GamesCatalogDomain

///
/// A provider that exposes feature flag states for the games catalog domain.
///
/// Bridges the feature access platform layer to the games catalog domain by
/// wrapping ``FeatureFlagging`` to provide game-specific feature flag checks.
///
final class FeatureFlagProvider: GamesCatalogDomain.FeatureFlagProviding {

    private let featureFlags: any FeatureFlagging

    ///
    /// Creates a feature flag provider.
    ///
    /// - Parameter featureFlags: The feature flags service for checking feature states.
    ///
    init(featureFlags: some FeatureFlagging) {
        self.featureFlags = featureFlags
    }

    ///
    /// Checks whether the Emoji Plot Decoder game is enabled.
    ///
    /// - Returns: `true` if the Emoji Plot Decoder game is enabled, `false` otherwise.
    ///
    func isEmojiPlotDecoderEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.emojiPlotDecoderGame)
    }

    ///
    /// Checks whether the Plot Remix game is enabled.
    ///
    /// - Returns: `true` if the Plot Remix game is enabled, `false` otherwise.
    ///
    func isPlotRemixGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.plotRemixGame)
    }

    ///
    /// Checks whether the Poster Pixelation game is enabled.
    ///
    /// - Returns: `true` if the Poster Pixelation game is enabled, `false` otherwise.
    ///
    func isPosterPixelationGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.posterPixelationGame)
    }

    ///
    /// Checks whether the Timeline Tangle game is enabled.
    ///
    /// - Returns: `true` if the Timeline Tangle game is enabled, `false` otherwise.
    ///
    func isTimelineTangleGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        featureFlags.isEnabled(.timelineTangleGame)
    }

}
