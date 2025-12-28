//
//  FeatureFlagProviding.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A provider for game-related feature flags.
///
/// This protocol defines the interface for checking which games are enabled
/// in the catalog based on feature flag configuration.
///
public protocol FeatureFlagProviding: Sendable {

    ///
    /// Checks whether the Plot Remix game is enabled.
    ///
    /// - Returns: `true` if the Plot Remix game is enabled, `false` otherwise.
    /// - Throws: ``FeatureFlagProviderError`` if the feature flag cannot be retrieved.
    ///
    func isPlotRemixGameEnabled() throws(FeatureFlagProviderError) -> Bool

    ///
    /// Checks whether the Emoji Plot Decoder game is enabled.
    ///
    /// - Returns: `true` if the Emoji Plot Decoder game is enabled, `false` otherwise.
    /// - Throws: ``FeatureFlagProviderError`` if the feature flag cannot be retrieved.
    ///
    func isEmojiPlotDecoderEnabled() throws(FeatureFlagProviderError) -> Bool

    ///
    /// Checks whether the Poster Pixelation game is enabled.
    ///
    /// - Returns: `true` if the Poster Pixelation game is enabled, `false` otherwise.
    /// - Throws: ``FeatureFlagProviderError`` if the feature flag cannot be retrieved.
    ///
    func isPosterPixelationGameEnabled() throws(FeatureFlagProviderError) -> Bool

    ///
    /// Checks whether the Timeline Tangle game is enabled.
    ///
    /// - Returns: `true` if the Timeline Tangle game is enabled, `false` otherwise.
    /// - Throws: ``FeatureFlagProviderError`` if the feature flag cannot be retrieved.
    ///
    func isTimelineTangleGameEnabled() throws(FeatureFlagProviderError) -> Bool

}

///
/// Errors that can occur when retrieving feature flags.
///
public enum FeatureFlagProviderError: Error {

    /// An unknown error occurred while retrieving the feature flag.
    case unknown(Error? = nil)

}
