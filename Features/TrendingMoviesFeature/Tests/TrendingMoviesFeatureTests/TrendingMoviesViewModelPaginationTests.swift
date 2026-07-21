//
//  TrendingMoviesViewModelPaginationTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TrendingMoviesFeature

@Suite("TrendingMoviesViewModel Pagination Tests")
struct TrendingMoviesViewModelPaginationTests {

    private typealias Support = TrendingMoviesTestSupport

    @Test(
        "load sets hasMore from the fetched page metadata",
        arguments: [(totalPages: 3, expectedHasMore: true), (totalPages: 1, expectedHasMore: false)]
    )
    @MainActor
    func loadSetsHasMore(totalPages: Int, expectedHasMore: Bool) async {
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchTrendingMovies: { page in
                    MoviePreviewPage(page: page, totalPages: totalPages, movies: Support.testMovies)
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
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

    @Test("loadMore skips a page of only-duplicate movies and appends the next")
    @MainActor
    func loadMoreSkipsFullyDuplicatePage() async {
        let page1 = [MoviePreview(id: 1, title: "1"), MoviePreview(id: 2, title: "2")]
        let page3 = [MoviePreview(id: 3, title: "3")]
        let requested = Mutex<[Int]>([])
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
                fetchTrendingMovies: { page in
                    let attemptNumber = attempt.withLock { $0 += 1; return $0 }
                    if attemptNumber == 1 {
                        throw TrendingMoviesTestError.generic
                    }
                    return MoviePreviewPage(page: page, totalPages: 1, movies: Support.testMovies)
                }
            )
        )

        await viewModel.load()
        #expect(viewModel.viewState.isError)

        viewModel.reload()
        await viewModel.load()

        #expect(viewModel.viewState.content?.movies == Support.testMovies)
        #expect(viewModel.hasMore == false)
    }

    @Test("loadMoreIfNeeded triggers a fetch for a cell within the threshold of the end")
    @MainActor
    func loadMoreIfNeededTriggersNearEnd() async {
        let page1 = (1 ... 20).map { MoviePreview(id: $0, title: "\($0)") }
        let requested = Mutex<[Int]>([])
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
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
        let viewModel = Support.makeViewModel(
            dependencies: Support.stubDependencies(
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

}
