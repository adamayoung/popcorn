//
//  PopularMoviesViewModelTests.swift
//  PopularMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopularMoviesFeature
import Presentation
import Synchronization
import Testing

@Suite("PopularMoviesViewModel Tests")
struct PopularMoviesViewModelTests {

    private typealias Support = PopularMoviesTestSupport

    @Test("load success builds a ready snapshot from the dependency")
    @MainActor
    func loadSuccessBuildsReadySnapshot() async {
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in Support.singlePage(Support.testMovies) }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.content?.movies == Support.testMovies)
    }

    @Test("load success with no movies is still ready, so the view shows its empty state")
    @MainActor
    func loadSuccessWithNoMoviesIsReady() async {
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in Support.singlePage([]) }
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in
                    fetchCalled.withLock { $0 = true }
                    throw PopularMoviesTestError.generic
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in
                    await observer.capture()
                    return Support.singlePage(Support.testMovies)
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in
                    fetchCount.withLock { $0 += 1 }
                    return Support.singlePage(Support.testMovies)
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in
                    fetchCount.withLock { $0 += 1 }
                    return Support.singlePage(Support.testMovies)
                }
            ),
            viewState: .ready(PopularMoviesViewSnapshot(movies: Support.testMovies))
        )

        await viewModel.load()

        #expect(fetchCount.withLock { $0 } == 0)
    }

    @Test("cancelled load resets to initial (no spurious error) so the next .task re-fetches")
    @MainActor
    func loadCancellationResetsToInitial() async {
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchPopularMovies: { _ in throw CancellationError() }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.isInitial)
        #expect(viewModel.viewState.isError == false)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Support.makeViewModel()

        let initialID = viewModel.reloadID
        viewModel.reload()

        #expect(viewModel.reloadID == initialID + 1)
    }

    @Test("selectMovie forwards the id and transitionID to the navigator")
    @MainActor
    func selectMovieInvokesNavigator() {
        let navigator = SpyPopularMoviesNavigator()
        let viewModel = Support.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: "456_popular-movies-grid")

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedMovieTransitionID == "456_popular-movies-grid")
    }

    @Test("selectMovie forwards a nil transitionID when there is no zoom source")
    @MainActor
    func selectMovieForwardsNilTransitionID() {
        let navigator = SpyPopularMoviesNavigator()
        let viewModel = Support.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 456, transitionID: nil)

        #expect(navigator.openedMovieID == 456)
        #expect(navigator.openedMovieTransitionID == nil)
    }

}
