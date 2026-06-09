//
//  GamesCatalogViewModelTests.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import GamesCatalogFeature
import Presentation
import SwiftUI
import Synchronization
import Testing

@Suite("GamesCatalogViewModel Tests")
struct GamesCatalogViewModelTests {

    @Test("fetch success loads games")
    @MainActor
    func fetchSuccessLoadsGames() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchGames: { Self.testGames })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(GamesCatalogViewSnapshot(games: Self.testGames)))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchGames: { throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = GamesCatalogViewSnapshot(games: Self.testGames)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchGames: { fetchCalled.withLock { $0 = true }; return Self.testGames }
            ),
            viewState: .ready(snapshot)
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(snapshot))
    }

    @Test("fetch is a no-op when already loading")
    @MainActor
    func fetchNoOpWhenLoading() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchGames: { fetchCalled.withLock { $0 = true }; return Self.testGames }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()
        let before = viewModel.reloadID

        viewModel.reload()

        #expect(viewModel.reloadID == before + 1)
    }

    @Test("selectGame invokes the navigator with the correct identifier")
    @MainActor
    func selectGameInvokesNavigator() {
        let navigator = SpyGamesCatalogNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectGame(id: 1)

        #expect(navigator.openedGameID == 1)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyGamesCatalogNavigator: GamesCatalogNavigating {
    var openedGameID: Int?

    func openGame(id: Int) {
        openedGameID = id
    }
}

// MARK: - Factories

extension GamesCatalogViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: GamesCatalogDependencies = stubDependencies(),
        navigator: any GamesCatalogNavigating = SpyGamesCatalogNavigator(),
        viewState: ViewState<GamesCatalogViewSnapshot> = .initial
    ) -> GamesCatalogViewModel {
        GamesCatalogViewModel(
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchGames: @escaping @Sendable () async throws -> [GameMetadata] = { testGames }
    ) -> GamesCatalogDependencies {
        GamesCatalogDependencies(fetchGames: fetchGames)
    }

}

// MARK: - Test Data

extension GamesCatalogViewModelTests {

    static let testGames = [
        GameMetadata(
            id: 1,
            name: "Plot Remix",
            description: "Decode the twisted summary.",
            iconSystemName: "movieclapper",
            color: .blue
        ),
        GameMetadata(
            id: 2,
            name: "Poster Pixelation",
            description: "Reveal the poster piece by piece.",
            iconSystemName: "photo.stack",
            color: .green
        )
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
