//
//  WatchlistViewModelTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import WatchlistFeature

@Suite("WatchlistViewModel Tests")
struct WatchlistViewModelTests {

    @Test("fetch success loads watchlist movies")
    @MainActor
    func fetchSuccessLoadsMovies() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchWatchlistMovies: { Self.testMovies })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(WatchlistViewSnapshot(movies: Self.testMovies)))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchWatchlistMovies: { throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("stream update replaces the loaded movies (loaded before updated)")
    @MainActor
    func streamUpdateReplacesMovies() async {
        let updatedMovies = [MoviePreview(id: 99, title: "Updated Movie")]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchWatchlistMovies: { Self.testMovies },
                streamWatchlistMovies: {
                    AsyncThrowingStream { continuation in
                        continuation.yield(updatedMovies)
                        continuation.finish()
                    }
                }
            )
        )

        await viewModel.fetch()
        await viewModel.observeUpdates()

        #expect(viewModel.viewState == .ready(WatchlistViewSnapshot(movies: updatedMovies)))
    }

    @Test("observeUpdates is a no-op before a successful fetch")
    @MainActor
    func observeUpdatesNoOpBeforeReady() async {
        let streamCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                streamWatchlistMovies: {
                    streamCalled.withLock { $0 = true }
                    return AsyncThrowingStream { $0.finish() }
                }
            )
        )

        await viewModel.observeUpdates()

        #expect(streamCalled.withLock { $0 } == false)
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = WatchlistViewSnapshot(movies: Self.testMovies)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchWatchlistMovies: { fetchCalled.withLock { $0 = true }; return Self.testMovies }
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
                fetchWatchlistMovies: { fetchCalled.withLock { $0 = true }; return Self.testMovies }
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

    @Test("selectMovie invokes the navigator with the id and transitionID")
    @MainActor
    func selectMovieInvokesNavigator() {
        let navigator = SpyWatchlistNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: "456")

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedTransitionID == "456")
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyWatchlistNavigator: WatchlistNavigating {
    var openedMovieID: Int?
    var openedTransitionID: String?

    func openMovieDetails(id: Int, transitionID: String?) {
        openedMovieID = id
        openedTransitionID = transitionID
    }
}

// MARK: - Factories

extension WatchlistViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: WatchlistDependencies = stubDependencies(),
        navigator: any WatchlistNavigating = SpyWatchlistNavigator(),
        viewState: ViewState<WatchlistViewSnapshot> = .initial
    ) -> WatchlistViewModel {
        WatchlistViewModel(
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchWatchlistMovies: @escaping @Sendable () async throws -> [MoviePreview] = { testMovies },
        streamWatchlistMovies: @escaping @Sendable () async throws -> AsyncThrowingStream<[MoviePreview], Error> = {
            AsyncThrowingStream { $0.finish() }
        }
    ) -> WatchlistDependencies {
        WatchlistDependencies(
            fetchWatchlistMovies: fetchWatchlistMovies,
            streamWatchlistMovies: streamWatchlistMovies
        )
    }

}

// MARK: - Test Data

extension WatchlistViewModelTests {

    static let testMovies = [
        MoviePreview(id: 1, title: "Movie 1"),
        MoviePreview(id: 2, title: "Movie 2")
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
