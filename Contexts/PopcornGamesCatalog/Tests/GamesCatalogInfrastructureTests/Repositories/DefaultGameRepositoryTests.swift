//
//  DefaultGameRepositoryTests.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain
@testable import GamesCatalogInfrastructure
import Testing

@Suite("DefaultGameRepository")
struct DefaultGameRepositoryTests {

    let mockFeatureFlagProvider: MockFeatureFlagProvider

    init() {
        self.mockFeatureFlagProvider = MockFeatureFlagProvider()
    }

    // MARK: - games() Success Cases

    @Test("games returns all games when all feature flags enabled")
    func gamesReturnsAllGamesWhenAllFlagsEnabled() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(true)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(true)

        let repository = makeRepository()

        let result = try await repository.games()

        #expect(result.count == 4)
    }

    @Test("games returns games sorted by name")
    func gamesReturnsSortedByName() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(true)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(true)

        let repository = makeRepository()

        let result = try await repository.games()

        let names = result.map(\.name)
        #expect(names == names.sorted())
    }

    // MARK: - games() Feature Flag Filtering

    @Test("games excludes Plot Remix when feature flag disabled")
    func gamesExcludesPlotRemixWhenFlagDisabled() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(false)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(true)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(true)

        let repository = makeRepository()

        let result = try await repository.games()

        #expect(result.count == 3)
        #expect(!result.contains { $0.id == 1 })
    }

    @Test("games excludes Poster Pixelation when feature flag disabled")
    func gamesExcludesPosterPixelationWhenFlagDisabled() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(false)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(true)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(true)

        let repository = makeRepository()

        let result = try await repository.games()

        #expect(result.count == 3)
        #expect(!result.contains { $0.id == 2 })
    }

    @Test("games excludes Emoji Plot Decoder when feature flag disabled")
    func gamesExcludesEmojiPlotDecoderWhenFlagDisabled() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(false)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(true)

        let repository = makeRepository()

        let result = try await repository.games()

        #expect(result.count == 3)
        #expect(!result.contains { $0.id == 3 })
    }

    @Test("games excludes Timeline Tangle when feature flag disabled")
    func gamesExcludesTimelineTangleWhenFlagDisabled() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(true)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(false)

        let repository = makeRepository()

        let result = try await repository.games()

        #expect(result.count == 3)
        #expect(!result.contains { $0.id == 4 })
    }

    @Test("games returns empty when all feature flags disabled")
    func gamesReturnsEmptyWhenAllFlagsDisabled() async throws {
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .success(false)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(false)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(false)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(false)

        let repository = makeRepository()

        let result = try await repository.games()

        #expect(result.isEmpty)
    }

    @Test("games handles feature flag provider error gracefully")
    func gamesHandlesFeatureFlagProviderErrorGracefully() async throws {
        let error = FeatureFlagProviderError.unknown(nil)
        mockFeatureFlagProvider.isPlotRemixGameEnabledStub = .failure(error)
        mockFeatureFlagProvider.isPosterPixelationGameEnabledStub = .success(true)
        mockFeatureFlagProvider.isEmojiPlotDecoderEnabledStub = .success(true)
        mockFeatureFlagProvider.isTimelineTangleGameEnabledStub = .success(true)

        let repository = makeRepository()

        let result = try await repository.games()

        // When feature flag throws, the game should be excluded (try? returns nil -> false)
        #expect(!result.contains { $0.id == 1 })
    }

    // MARK: - game(id:) Success Cases

    @Test("game returns correct game for valid ID")
    func gameReturnsCorrectGameForValidID() async throws {
        let repository = makeRepository()

        let result = try await repository.game(id: 1)

        #expect(result.id == 1)
        #expect(result.name == "Plot Remix")
    }

    @Test("game returns Plot Remix for ID 1")
    func gameReturnsPlotRemixForID1() async throws {
        let repository = makeRepository()

        let result = try await repository.game(id: 1)

        #expect(result.name == "Plot Remix")
        #expect(result.color == .blue)
    }

    @Test("game returns Poster Pixelation for ID 2")
    func gameReturnsPosterPixelationForID2() async throws {
        let repository = makeRepository()

        let result = try await repository.game(id: 2)

        #expect(result.name == "Poster Pixelation")
        #expect(result.color == .green)
    }

    @Test("game returns Emoji Plot Decoder for ID 3")
    func gameReturnsEmojiPlotDecoderForID3() async throws {
        let repository = makeRepository()

        let result = try await repository.game(id: 3)

        #expect(result.name == "Emoji Plot Decoder")
        #expect(result.color == .red)
    }

    @Test("game returns Timeline Tangle for ID 4")
    func gameReturnsTimelineTangleForID4() async throws {
        let repository = makeRepository()

        let result = try await repository.game(id: 4)

        #expect(result.name == "Timeline Tangle")
        #expect(result.color == .yellow)
    }

    // MARK: - game(id:) Error Cases

    @Test("game throws notFound for invalid ID")
    func gameThrowsNotFoundForInvalidID() async {
        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.game(id: 999)
            },
            throws: { error in
                guard let repoError = error as? GameRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("game throws notFound for ID 0")
    func gameThrowsNotFoundForID0() async {
        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.game(id: 0)
            },
            throws: { error in
                guard let repoError = error as? GameRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("game throws notFound for negative ID")
    func gameThrowsNotFoundForNegativeID() async {
        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.game(id: -1)
            },
            throws: { error in
                guard let repoError = error as? GameRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultGameRepository {
        DefaultGameRepository(featureFlagProvider: mockFeatureFlagProvider)
    }

}
