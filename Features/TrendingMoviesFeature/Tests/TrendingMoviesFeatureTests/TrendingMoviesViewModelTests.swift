//
//  TrendingMoviesViewModelTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TrendingMoviesFeature

@Suite("TrendingMoviesViewModel Tests")
struct TrendingMoviesViewModelTests {

    @Test("load success builds a ready snapshot from the dependency")
    @MainActor
    func loadSuccessBuildsReadySnapshot() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { Self.testMovies }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.content?.movies == Self.testMovies)
    }

    @Test("load success with no movies is still ready, so the view shows its empty state")
    @MainActor
    func loadSuccessWithNoMoviesIsReady() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { [] }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.isReady)
        #expect(viewModel.viewState.content?.movies.isEmpty == true)
    }

    @Test("load failure sets viewState to error")
    @MainActor
    func loadFailureSetsError() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: {
                    fetchCalled.withLock { $0 = true }
                    throw TestError.generic
                }
            )
        )

        await viewModel.load()

        #expect(fetchCalled.withLock { $0 } == true)
        #expect(viewModel.viewState.isError)
    }

    @Test("load sets viewState to loading while fetching, then clears it")
    @MainActor
    func loadSetsLoadingWhileFetching() async {
        let observer = LoadingObserver()
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: {
                    await observer.capture()
                    return Self.testMovies
                }
            )
        )
        observer.viewModel = viewModel

        #expect(viewModel.viewState.isLoading == false)
        await viewModel.load()

        #expect(observer.loadingDuringFetch == true)
        #expect(viewModel.viewState.isLoading == false)
    }

    @Test("load is a no-op when already loading (guards re-entrancy)")
    @MainActor
    func loadNoOpWhenLoading() async {
        let fetchCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: {
                    fetchCount.withLock { $0 += 1 }
                    return Self.testMovies
                }
            ),
            viewState: .loading
        )

        await viewModel.load()

        #expect(fetchCount.withLock { $0 } == 0)
    }

    @Test("load is a no-op when already ready")
    @MainActor
    func loadNoOpWhenReady() async {
        let fetchCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: {
                    fetchCount.withLock { $0 += 1 }
                    return Self.testMovies
                }
            ),
            viewState: .ready(TrendingMoviesViewSnapshot(movies: Self.testMovies))
        )

        await viewModel.load()

        #expect(fetchCount.withLock { $0 } == 0)
    }

    @Test("cancelled load resets to initial (no spurious error) so the next .task re-fetches")
    @MainActor
    func loadCancellationResetsToInitial() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { throw CancellationError() }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.isInitial)
        #expect(viewModel.viewState.isError == false)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()

        let initialID = viewModel.reloadID
        viewModel.reload()

        #expect(viewModel.reloadID == initialID + 1)
    }

    @Test("selectMovie forwards the id and transitionID to the navigator")
    @MainActor
    func selectMovieInvokesNavigator() {
        let navigator = SpyTrendingMoviesNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: "456_trending-movies-grid")

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedMovieTransitionID == "456_trending-movies-grid")
    }

    @Test("selectMovie forwards a nil transitionID when there is no zoom source")
    @MainActor
    func selectMovieForwardsNilTransitionID() {
        let navigator = SpyTrendingMoviesNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: nil)

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedMovieTransitionID == nil)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTrendingMoviesNavigator: TrendingMoviesNavigating {
    var openedMovieID: Int?
    var openedMovieTransitionID: String?

    func openMovieDetails(id: Int, transitionID: String?) {
        openedMovieID = id
        openedMovieTransitionID = transitionID
    }
}

// MARK: - Loading Observer

/// Captures the view model's loading state at the moment the fetch closure runs,
/// so a test can assert loading was set before the network call resolves.
@MainActor
private final class LoadingObserver {
    weak var viewModel: TrendingMoviesViewModel?
    var loadingDuringFetch = false

    func capture() {
        loadingDuringFetch = viewModel?.viewState.isLoading ?? false
    }
}

// MARK: - Factories

extension TrendingMoviesViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TrendingMoviesDependencies = stubDependencies(),
        navigator: any TrendingMoviesNavigating = SpyTrendingMoviesNavigator(),
        viewState: ViewState<TrendingMoviesViewSnapshot> = .initial
    ) -> TrendingMoviesViewModel {
        TrendingMoviesViewModel(
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchTrendingMovies: @escaping @Sendable () async throws -> [MoviePreview] = { [] }
    ) -> TrendingMoviesDependencies {
        TrendingMoviesDependencies(
            fetchTrendingMovies: fetchTrendingMovies
        )
    }

}

// MARK: - Test Data

extension TrendingMoviesViewModelTests {

    static let testMovies = [
        MoviePreview(id: 1, title: "Movie 1"),
        MoviePreview(id: 2, title: "Movie 2")
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
