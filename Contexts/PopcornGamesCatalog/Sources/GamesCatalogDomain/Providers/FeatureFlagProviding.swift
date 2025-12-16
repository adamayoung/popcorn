//
//  FeatureFlagProviding.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public protocol FeatureFlagProviding: Sendable {

    func isPlotRemixGameEnabled() throws(FeatureFlagProviderError) -> Bool

    func isEmojiPlotDecoderEnabled() throws(FeatureFlagProviderError) -> Bool

    func isPosterPixelationGameEnabled() throws(FeatureFlagProviderError) -> Bool

    func isTimelineTangleGameEnabled() throws(FeatureFlagProviderError) -> Bool

}

public enum FeatureFlagProviderError: Error {

    case unknown(Error? = nil)

}
