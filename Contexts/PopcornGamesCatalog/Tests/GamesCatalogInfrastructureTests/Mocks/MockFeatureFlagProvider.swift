//
//  MockFeatureFlagProvider.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

final class MockFeatureFlagProvider: FeatureFlagProviding, @unchecked Sendable {

    var isPlotRemixGameEnabledCallCount = 0
    var isPlotRemixGameEnabledStub: Result<Bool, FeatureFlagProviderError> = .success(true)

    func isPlotRemixGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        isPlotRemixGameEnabledCallCount += 1
        switch isPlotRemixGameEnabledStub {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    var isEmojiPlotDecoderEnabledCallCount = 0
    var isEmojiPlotDecoderEnabledStub: Result<Bool, FeatureFlagProviderError> = .success(true)

    func isEmojiPlotDecoderEnabled() throws(FeatureFlagProviderError) -> Bool {
        isEmojiPlotDecoderEnabledCallCount += 1
        switch isEmojiPlotDecoderEnabledStub {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    var isPosterPixelationGameEnabledCallCount = 0
    var isPosterPixelationGameEnabledStub: Result<Bool, FeatureFlagProviderError> = .success(true)

    func isPosterPixelationGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        isPosterPixelationGameEnabledCallCount += 1
        switch isPosterPixelationGameEnabledStub {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    var isTimelineTangleGameEnabledCallCount = 0
    var isTimelineTangleGameEnabledStub: Result<Bool, FeatureFlagProviderError> = .success(true)

    func isTimelineTangleGameEnabled() throws(FeatureFlagProviderError) -> Bool {
        isTimelineTangleGameEnabledCallCount += 1
        switch isTimelineTangleGameEnabledStub {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

}
