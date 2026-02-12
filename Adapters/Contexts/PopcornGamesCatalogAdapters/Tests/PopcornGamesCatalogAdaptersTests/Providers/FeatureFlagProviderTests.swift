//
//  FeatureFlagProviderTests.swift
//  PopcornGamesCatalogAdapters
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
import FeatureAccessTestHelpers
import Foundation
@testable import PopcornGamesCatalogAdapters
import Testing

@Suite("FeatureFlagProvider Tests")
struct FeatureFlagProviderTests {

    let mockFeatureFlags: MockFeatureFlags

    init() {
        self.mockFeatureFlags = MockFeatureFlags()
    }

    // MARK: - isEmojiPlotDecoderEnabled

    @Test("isEmojiPlotDecoderEnabled returns true when flag is enabled")
    func isEmojiPlotDecoderEnabledReturnsTrueWhenEnabled() throws {
        mockFeatureFlags.enabledFlags = [.emojiPlotDecoderGame]

        let provider = makeProvider()

        let result = try provider.isEmojiPlotDecoderEnabled()

        #expect(result == true)
    }

    @Test("isEmojiPlotDecoderEnabled returns false when flag is disabled")
    func isEmojiPlotDecoderEnabledReturnsFalseWhenDisabled() throws {
        mockFeatureFlags.enabledFlags = []

        let provider = makeProvider()

        let result = try provider.isEmojiPlotDecoderEnabled()

        #expect(result == false)
    }

    @Test("isEmojiPlotDecoderEnabled calls feature flags with correct flag")
    func isEmojiPlotDecoderEnabledCallsFeatureFlagsWithCorrectFlag() throws {
        let provider = makeProvider()

        _ = try provider.isEmojiPlotDecoderEnabled()

        #expect(mockFeatureFlags.isEnabledCalledWithFlags.contains(.emojiPlotDecoderGame))
    }

    // MARK: - isPlotRemixGameEnabled

    @Test("isPlotRemixGameEnabled returns true when flag is enabled")
    func isPlotRemixGameEnabledReturnsTrueWhenEnabled() throws {
        mockFeatureFlags.enabledFlags = [.plotRemixGame]

        let provider = makeProvider()

        let result = try provider.isPlotRemixGameEnabled()

        #expect(result == true)
    }

    @Test("isPlotRemixGameEnabled returns false when flag is disabled")
    func isPlotRemixGameEnabledReturnsFalseWhenDisabled() throws {
        mockFeatureFlags.enabledFlags = []

        let provider = makeProvider()

        let result = try provider.isPlotRemixGameEnabled()

        #expect(result == false)
    }

    @Test("isPlotRemixGameEnabled calls feature flags with correct flag")
    func isPlotRemixGameEnabledCallsFeatureFlagsWithCorrectFlag() throws {
        let provider = makeProvider()

        _ = try provider.isPlotRemixGameEnabled()

        #expect(mockFeatureFlags.isEnabledCalledWithFlags.contains(.plotRemixGame))
    }

    // MARK: - isPosterPixelationGameEnabled

    @Test("isPosterPixelationGameEnabled returns true when flag is enabled")
    func isPosterPixelationGameEnabledReturnsTrueWhenEnabled() throws {
        mockFeatureFlags.enabledFlags = [.posterPixelationGame]

        let provider = makeProvider()

        let result = try provider.isPosterPixelationGameEnabled()

        #expect(result == true)
    }

    @Test("isPosterPixelationGameEnabled returns false when flag is disabled")
    func isPosterPixelationGameEnabledReturnsFalseWhenDisabled() throws {
        mockFeatureFlags.enabledFlags = []

        let provider = makeProvider()

        let result = try provider.isPosterPixelationGameEnabled()

        #expect(result == false)
    }

    @Test("isPosterPixelationGameEnabled calls feature flags with correct flag")
    func isPosterPixelationGameEnabledCallsFeatureFlagsWithCorrectFlag() throws {
        let provider = makeProvider()

        _ = try provider.isPosterPixelationGameEnabled()

        #expect(mockFeatureFlags.isEnabledCalledWithFlags.contains(.posterPixelationGame))
    }

    // MARK: - isTimelineTangleGameEnabled

    @Test("isTimelineTangleGameEnabled returns true when flag is enabled")
    func isTimelineTangleGameEnabledReturnsTrueWhenEnabled() throws {
        mockFeatureFlags.enabledFlags = [.timelineTangleGame]

        let provider = makeProvider()

        let result = try provider.isTimelineTangleGameEnabled()

        #expect(result == true)
    }

    @Test("isTimelineTangleGameEnabled returns false when flag is disabled")
    func isTimelineTangleGameEnabledReturnsFalseWhenDisabled() throws {
        mockFeatureFlags.enabledFlags = []

        let provider = makeProvider()

        let result = try provider.isTimelineTangleGameEnabled()

        #expect(result == false)
    }

    @Test("isTimelineTangleGameEnabled calls feature flags with correct flag")
    func isTimelineTangleGameEnabledCallsFeatureFlagsWithCorrectFlag() throws {
        let provider = makeProvider()

        _ = try provider.isTimelineTangleGameEnabled()

        #expect(mockFeatureFlags.isEnabledCalledWithFlags.contains(.timelineTangleGame))
    }

    // MARK: - Multiple Flags

    @Test("Multiple game flags can be enabled simultaneously")
    func multipleGameFlagsCanBeEnabledSimultaneously() throws {
        mockFeatureFlags.enabledFlags = [
            .emojiPlotDecoderGame,
            .plotRemixGame,
            .posterPixelationGame,
            .timelineTangleGame
        ]

        let provider = makeProvider()

        #expect(try provider.isEmojiPlotDecoderEnabled() == true)
        #expect(try provider.isPlotRemixGameEnabled() == true)
        #expect(try provider.isPosterPixelationGameEnabled() == true)
        #expect(try provider.isTimelineTangleGameEnabled() == true)
    }

    @Test("Some game flags enabled and some disabled")
    func someGameFlagsEnabledAndSomeDisabled() throws {
        mockFeatureFlags.enabledFlags = [.plotRemixGame, .timelineTangleGame]

        let provider = makeProvider()

        #expect(try provider.isEmojiPlotDecoderEnabled() == false)
        #expect(try provider.isPlotRemixGameEnabled() == true)
        #expect(try provider.isPosterPixelationGameEnabled() == false)
        #expect(try provider.isTimelineTangleGameEnabled() == true)
    }

    // MARK: - Helpers

    private func makeProvider() -> FeatureFlagProvider {
        FeatureFlagProvider(featureFlags: mockFeatureFlags)
    }

}
