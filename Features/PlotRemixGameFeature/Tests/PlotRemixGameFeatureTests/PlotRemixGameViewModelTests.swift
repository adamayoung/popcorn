//
//  PlotRemixGameViewModelTests.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PlotRemixGameFeature
import SwiftUI
import Synchronization
import Testing

@Suite("PlotRemixGameViewModel Tests")
struct PlotRemixGameViewModelTests {

    @Test("fetchMetadata success loads metadata")
    @MainActor
    func fetchMetadataSuccess() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(gameMetadata: { _ in Self.testMetadata })
        )

        await viewModel.fetchMetadata()

        #expect(viewModel.metadata == Self.testMetadata)
        #expect(viewModel.error == nil)
    }

    @Test("fetchMetadata failure sets error")
    @MainActor
    func fetchMetadataFailure() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(gameMetadata: { _ in throw TestError.generic })
        )

        await viewModel.fetchMetadata()

        #expect(viewModel.metadata == nil)
        #expect(viewModel.error as? TestError == .generic)
    }

    @Test("fetchMetadata is a no-op when metadata already loaded")
    @MainActor
    func fetchMetadataNoOpWhenLoaded() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                gameMetadata: { _ in fetchCalled.withLock { $0 = true }; return Self.testMetadata }
            ),
            metadata: Self.testMetadata
        )

        await viewModel.fetchMetadata()

        #expect(fetchCalled.withLock { $0 } == false)
    }

    @Test("startGenerating marks generating and bumps the generate token")
    @MainActor
    func startGeneratingBumpsToken() {
        let viewModel = Self.makeViewModel(metadata: Self.testMetadata)
        let before = viewModel.generateToken

        viewModel.startGenerating()

        #expect(viewModel.isGeneratingGame)
        #expect(viewModel.generateToken == before + 1)
    }

    @Test("generateGame reports progress and starts the game on success")
    @MainActor
    func generateGameSuccess() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                generateGame: { progress in
                    progress(0.5)
                    return Self.testGame
                }
            ),
            metadata: Self.testMetadata
        )
        viewModel.startGenerating()

        await viewModel.generateGame()
        await Self.drainProgress(viewModel, expected: 0.5)

        #expect(viewModel.game == Self.testGame)
        #expect(viewModel.generatingProgress == 0.5)
    }

    @Test("generateGame is a no-op without metadata")
    @MainActor
    func generateGameNoOpWithoutMetadata() async {
        let generateCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                generateGame: { _ in generateCalled.withLock { $0 = true }; return Self.testGame }
            )
        )
        viewModel.startGenerating()

        await viewModel.generateGame()

        #expect(generateCalled.withLock { $0 } == false)
        #expect(viewModel.game == nil)
    }

    @Test("generateGame failure clears progress and records the error")
    @MainActor
    func generateGameFailure() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                generateGame: { _ in throw TestError.generic }
            ),
            metadata: Self.testMetadata
        )
        viewModel.startGenerating()

        await viewModel.generateGame()

        #expect(viewModel.game == nil)
        #expect(viewModel.generatingProgress == nil)
        #expect(viewModel.isGeneratingGame == false)
        #expect(viewModel.error as? TestError == .generic)
    }

    @Test("close cancels in-flight generation before dismissing")
    @MainActor
    func closeCancelsThenDismisses() async {
        let navigator = SpyPlotRemixGameNavigator()
        let started = AsyncStream<Void>.makeStream()
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                generateGame: { _ in
                    started.continuation.yield()
                    started.continuation.finish()
                    // Never returns until cancelled.
                    while !Task.isCancelled {
                        await Task.yield()
                    }
                    throw CancellationError()
                }
            ),
            navigator: navigator,
            metadata: Self.testMetadata
        )
        viewModel.startGenerating()

        let generateTask = Task { await viewModel.generateGame() }
        var iterator = started.stream.makeAsyncIterator()
        _ = await iterator.next() // Wait until generation is in flight.

        await viewModel.close()
        await generateTask.value

        #expect(viewModel.game == nil)
        #expect(navigator.didDismiss)
    }

    @Test("close dismisses via the navigator when nothing is generating")
    @MainActor
    func closeDismisses() async {
        let navigator = SpyPlotRemixGameNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        await viewModel.close()

        #expect(navigator.didDismiss)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyPlotRemixGameNavigator: PlotRemixGameNavigating {
    var didDismiss = false

    func dismiss() {
        didDismiss = true
    }
}

// MARK: - Factories

extension PlotRemixGameViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: PlotRemixGameDependencies = stubDependencies(),
        navigator: any PlotRemixGameNavigating = SpyPlotRemixGameNavigator(),
        metadata: GameMetadata? = nil
    ) -> PlotRemixGameViewModel {
        PlotRemixGameViewModel(
            gameID: 1,
            dependencies: dependencies,
            navigator: navigator,
            metadata: metadata
        )
    }

    static func stubDependencies(
        gameMetadata: @escaping @Sendable (Int) async throws -> GameMetadata = { _ in testMetadata },
        generateGame: @escaping @Sendable (@Sendable @escaping (Float) -> Void) async throws -> Game = { _ in
            testGame
        }
    ) -> PlotRemixGameDependencies {
        PlotRemixGameDependencies(gameMetadata: gameMetadata, generateGame: generateGame)
    }

    /// Yields the main actor until the detached progress hop has applied, or a
    /// bounded number of times to avoid hanging if it never does.
    @MainActor
    static func drainProgress(_ viewModel: PlotRemixGameViewModel, expected: Float) async {
        for _ in 0 ..< 100 where viewModel.generatingProgress != expected {
            await Task.yield()
        }
    }

}

// MARK: - Test Data

extension PlotRemixGameViewModelTests {

    static let testMetadata = GameMetadata(
        id: 1,
        name: "Plot Remix",
        description: "Decode the twisted summary.",
        iconSystemName: "movieclapper",
        color: .blue
    )

    static let testGame = Game(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID(),
        questions: []
    )

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
