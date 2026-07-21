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
                fetchTrendingMovies: { _ in Self.singlePage(Self.testMovies) }
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
                fetchTrendingMovies: { _ in Self.singlePage([]) }
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
                fetchTrendingMovies: { _ in
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
                fetchTrendingMovies: { _ in
                    await observer.capture()
                    return Self.singlePage(Self.testMovies)
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
                fetchTrendingMovies: { _ in
                    fetchCount.withLock { $0 += 1 }
                    return Self.singlePage(Self.testMovies)
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
                fetchTrendingMovies: { _ in
                    fetchCount.withLock { $0 += 1 }
                    return Self.singlePage(Self.testMovies)
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
                fetchTrendingMovies: { _ in throw CancellationError() }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState.isInitial)
        #expect(viewModel.viewState.isError == false)
    }

    // MARK: - Pagination

    @Test(
        "load sets hasMore from the fetched page metadata",
        arguments: [(totalPages: 3, expectedHasMore: true), (totalPages: 1, expectedHasMore: false)]
    )
    @MainActor
    func loadSetsHasMore(totalPages: Int, expectedHasMore: Bool) async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    MoviePreviewPage(page: page, totalPages: totalPages, movies: Self.testMovies)
                }
            )
        )

        await viewModel.load()

        #expect(viewModel.hasMore == expectedHasMore)
    }

    @Test("loadMore fetches the next page and appends its movies")
    @MainActor
    func loadMoreAppendsNextPage() async {
        let page1 = [MoviePreview(id: 1, title: "1"), MoviePreview(id: 2, title: "2")]
        let page2 = [MoviePreview(id: 3, title: "3"), MoviePreview(id: 4, title: "4")]
        let requested = Mutex<[Int]>([])
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    requested.withLock { $0.append(page) }
                    return page == 1
                        ? MoviePreviewPage(page: 1, totalPages: 2, movies: page1)
                        : MoviePreviewPage(page: 2, totalPages: 2, movies: page2)
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        #expect(requested.withLock { $0 } == [1, 2])
        #expect(viewModel.viewState.content?.movies == page1 + page2)
        #expect(viewModel.hasMore == false)
        #expect(viewModel.isLoadingMore == false)
    }

    @Test("loadMore de-duplicates movies across pages and within a page, preserving order")
    @MainActor
    func loadMoreDeduplicates() async {
        let page1 = [MoviePreview(id: 1, title: "1"), MoviePreview(id: 2, title: "2")]
        // Repeats id 2 (cross-page) and id 3 twice (within-page).
        let page2 = [
            MoviePreview(id: 2, title: "2"),
            MoviePreview(id: 3, title: "3"),
            MoviePreview(id: 3, title: "3 again"),
            MoviePreview(id: 4, title: "4")
        ]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    page == 1
                        ? MoviePreviewPage(page: 1, totalPages: 2, movies: page1)
                        : MoviePreviewPage(page: 2, totalPages: 2, movies: page2)
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        #expect(viewModel.viewState.content?.movies.map(\.id) == [1, 2, 3, 4])
    }

    @Test("loadMore is a no-op when there are no more pages")
    @MainActor
    func loadMoreNoOpWhenNoMorePages() async {
        let fetchCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    fetchCount.withLock { $0 += 1 }
                    return MoviePreviewPage(page: page, totalPages: 1, movies: Self.testMovies)
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        #expect(fetchCount.withLock { $0 } == 1)
        #expect(viewModel.hasMore == false)
    }

    @Test("loadMore is a no-op when the view state is not ready")
    @MainActor
    func loadMoreNoOpWhenNotReady() async {
        let fetchCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    fetchCount.withLock { $0 += 1 }
                    return MoviePreviewPage(page: page, totalPages: 5, movies: Self.testMovies)
                }
            )
        )

        await viewModel.loadMore()

        #expect(fetchCount.withLock { $0 } == 0)
    }

    @Test("loadMore ignores a re-entrant call while a fetch is already in flight")
    @MainActor
    func loadMoreReentrancyGuard() async {
        let page2FetchCount = Mutex(0)
        let observer = LoadMoreObserver()
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    if page == 1 {
                        return MoviePreviewPage(page: 1, totalPages: 5, movies: [MoviePreview(id: 1, title: "1")])
                    }
                    page2FetchCount.withLock { $0 += 1 }
                    await observer.capture()
                    return MoviePreviewPage(page: 2, totalPages: 5, movies: [MoviePreview(id: 2, title: "2")])
                }
            )
        )
        observer.viewModel = viewModel
        observer.onFetch = { [weak viewModel] in
            // Re-enter while the first load-more is suspended; must bail on the guard.
            await viewModel?.loadMore()
        }

        await viewModel.load()
        await viewModel.loadMore()

        #expect(observer.loadingMoreDuringFetch == true)
        #expect(page2FetchCount.withLock { $0 } == 1)
    }

    @Test("isLoadingMore is true during a load-more fetch and false afterwards")
    @MainActor
    func isLoadingMoreDuringFetch() async {
        let observer = LoadMoreObserver()
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    if page == 1 {
                        return MoviePreviewPage(page: 1, totalPages: 3, movies: Self.testMovies)
                    }
                    await observer.capture()
                    return MoviePreviewPage(page: 2, totalPages: 3, movies: [MoviePreview(id: 99, title: "99")])
                }
            )
        )
        observer.viewModel = viewModel

        await viewModel.load()
        #expect(viewModel.isLoadingMore == false)
        await viewModel.loadMore()

        #expect(observer.loadingMoreDuringFetch == true)
        #expect(viewModel.isLoadingMore == false)
    }

    @Test("a failed load-more keeps the grid, resets isLoadingMore, and leaves paging retryable")
    @MainActor
    func loadMoreFailureIsNonFatal() async {
        let page1 = [MoviePreview(id: 1, title: "1")]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    if page == 1 {
                        return MoviePreviewPage(page: 1, totalPages: 3, movies: page1)
                    }
                    throw TestError.generic
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        #expect(viewModel.viewState.content?.movies == page1)
        #expect(viewModel.viewState.isReady)
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.hasMore == true)
    }

    @Test("a cancelled load-more leaves the loaded grid and state unchanged")
    @MainActor
    func loadMoreCancellationIsSilent() async {
        let page1 = [MoviePreview(id: 1, title: "1")]
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    if page == 1 {
                        return MoviePreviewPage(page: 1, totalPages: 3, movies: page1)
                    }
                    throw CancellationError()
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        #expect(viewModel.viewState.content?.movies == page1)
        #expect(viewModel.viewState.isReady)
        #expect(viewModel.isLoadingMore == false)
    }

    @Test("loadMoreIfNeeded triggers a fetch for a cell within the threshold of the end")
    @MainActor
    func loadMoreIfNeededTriggersNearEnd() async {
        let page1 = (1 ... 20).map { MoviePreview(id: $0, title: "\($0)") }
        let requested = Mutex<[Int]>([])
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    requested.withLock { $0.append(page) }
                    return page == 1
                        ? MoviePreviewPage(page: 1, totalPages: 3, movies: page1)
                        : MoviePreviewPage(page: 2, totalPages: 3, movies: [MoviePreview(id: 99, title: "99")])
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMoreIfNeeded(at: 19)

        #expect(requested.withLock { $0 } == [1, 2])
    }

    @Test("loadMoreIfNeeded does not fetch for a cell far from the end")
    @MainActor
    func loadMoreIfNeededIgnoresEarlyCell() async {
        let page1 = (1 ... 20).map { MoviePreview(id: $0, title: "\($0)") }
        let requested = Mutex<[Int]>([])
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    requested.withLock { $0.append(page) }
                    return MoviePreviewPage(page: 1, totalPages: 3, movies: page1)
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMoreIfNeeded(at: 0)

        #expect(requested.withLock { $0 } == [1])
    }

    @Test("loadMore skips a page of only-duplicate movies and appends the next")
    @MainActor
    func loadMoreSkipsFullyDuplicatePage() async {
        let page1 = [MoviePreview(id: 1, title: "1"), MoviePreview(id: 2, title: "2")]
        let page3 = [MoviePreview(id: 3, title: "3")]
        let requested = Mutex<[Int]>([])
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    requested.withLock { $0.append(page) }
                    switch page {
                    case 1: return MoviePreviewPage(page: 1, totalPages: 4, movies: page1)
                    case 2: return MoviePreviewPage(page: 2, totalPages: 4, movies: page1) // all duplicates
                    default: return MoviePreviewPage(page: 3, totalPages: 4, movies: page3)
                    }
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        #expect(requested.withLock { $0 } == [1, 2, 3])
        #expect(viewModel.viewState.content?.movies.map(\.id) == [1, 2, 3])
    }

    @Test("a fresh load after an error resets pagination to the new first page")
    @MainActor
    func loadResetsPaginationState() async {
        let attempt = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingMovies: { page in
                    let n = attempt.withLock { $0 += 1; return $0 }
                    if n == 1 {
                        throw TestError.generic
                    }
                    return MoviePreviewPage(page: page, totalPages: 1, movies: Self.testMovies)
                }
            )
        )

        await viewModel.load()
        #expect(viewModel.viewState.isError)

        viewModel.reload()
        await viewModel.load()

        #expect(viewModel.viewState.content?.movies == Self.testMovies)
        #expect(viewModel.hasMore == false)
    }

    // MARK: - Navigation & reload

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

// MARK: - Load-More Observer

/// Captures `isLoadingMore` while a load-more fetch is in flight, and optionally
/// runs an action (e.g. a re-entrant `loadMore`) at that same moment.
@MainActor
private final class LoadMoreObserver {
    weak var viewModel: TrendingMoviesViewModel?
    var loadingMoreDuringFetch = false
    var onFetch: (@MainActor () async -> Void)?

    func capture() async {
        loadingMoreDuringFetch = viewModel?.isLoadingMore ?? false
        if let onFetch {
            await onFetch()
        }
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
        fetchTrendingMovies: @escaping @Sendable (Int) async throws -> MoviePreviewPage = { page in
            MoviePreviewPage(page: page, totalPages: 1, movies: [])
        }
    ) -> TrendingMoviesDependencies {
        TrendingMoviesDependencies(
            fetchTrendingMovies: fetchTrendingMovies
        )
    }

    /// A single-page result (no further pages) wrapping `movies`.
    static func singlePage(_ movies: [MoviePreview]) -> MoviePreviewPage {
        MoviePreviewPage(page: 1, totalPages: 1, movies: movies)
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
