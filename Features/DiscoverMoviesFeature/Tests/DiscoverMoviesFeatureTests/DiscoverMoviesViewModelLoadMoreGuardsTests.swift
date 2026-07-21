//
//  DiscoverMoviesViewModelLoadMoreGuardsTests.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import DiscoverMoviesFeature
import Foundation
import Presentation
import Synchronization
import Testing

@Suite("DiscoverMoviesViewModel Load-More Guards Tests")
struct DiscoverMoviesViewModelLoadMoreGuardsTests {

    private typealias Support = DiscoverMoviesTestSupport

    @Test("loadMore is a no-op when there are no more pages")
    @MainActor
    func loadMoreNoOpWhenNoMorePages() async {
        let fetchCount = Mutex(0)
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
                    fetchCount.withLock { $0 += 1 }
                    return MoviePreviewPage(page: page, totalPages: 1, movies: Support.testMovies)
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
                    fetchCount.withLock { $0 += 1 }
                    return MoviePreviewPage(page: page, totalPages: 5, movies: Support.testMovies)
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
                    if page == 1 {
                        return MoviePreviewPage(page: 1, totalPages: 3, movies: Support.testMovies)
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
                    if page == 1 {
                        return MoviePreviewPage(page: 1, totalPages: 3, movies: page1)
                    }
                    throw DiscoverMoviesTestError.generic
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
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

    @Test("loadMore gives up after maxLoadMoreAttempts when every fetched page is only duplicates")
    @MainActor
    func loadMoreStopsAfterMaxAttemptsOnDuplicatePages() async {
        let page1 = [MoviePreview(id: 1, title: "1"), MoviePreview(id: 2, title: "2")]
        let requested = Mutex<[Int]>([])
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchDiscoverMovies: { page in
                    requested.withLock { $0.append(page) }
                    // Plenty of pages remain, but every one only repeats page 1.
                    return MoviePreviewPage(page: page, totalPages: 10, movies: page1)
                }
            )
        )

        await viewModel.load()
        await viewModel.loadMore()

        // 1 initial load + exactly maxLoadMoreAttempts (3) duplicate fetches, then it stops.
        #expect(requested.withLock { $0 } == [1, 2, 3, 4])
        #expect(viewModel.viewState.content?.movies == page1)
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.hasMore == true)
    }

}
