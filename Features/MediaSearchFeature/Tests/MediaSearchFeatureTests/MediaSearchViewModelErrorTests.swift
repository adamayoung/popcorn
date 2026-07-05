//
//  MediaSearchViewModelErrorTests.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import MediaSearchFeature
import Presentation
import Synchronization
import Testing

/// Covers the `.error` view state and ``MediaSearchViewModel/retry()``, split out
/// from ``MediaSearchViewModelTests`` to keep that file under the project's
/// file-length limit. Shares its fixtures (`makeViewModel`, `stubDependencies`,
/// test data, `TestError`) with that suite.
@Suite("MediaSearchViewModel Error Handling Tests")
struct MediaSearchViewModelErrorTests {

    @Test("fetchGenresAndSearchHistory failure surfaces an error state")
    @MainActor
    func fetchFailureShowsError() async {
        let viewModel = MediaSearchViewModelTests.makeViewModel(
            dependencies: MediaSearchViewModelTests.stubDependencies(
                fetchGenres: { throw TestError.generic }
            )
        )

        await viewModel.fetchGenresAndSearchHistory()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("search failure surfaces an error state")
    @MainActor
    func searchFailureShowsError() async {
        let viewModel = MediaSearchViewModelTests.makeViewModel(
            dependencies: MediaSearchViewModelTests.stubDependencies(
                search: { _ in throw TestError.generic }
            ),
            query: "running"
        )

        await viewModel.search()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("search cancellation does not surface an error state")
    @MainActor
    func searchCancellationDoesNotShowError() async {
        let viewModel = MediaSearchViewModelTests.makeViewModel(
            dependencies: MediaSearchViewModelTests.stubDependencies(
                search: { _ in throw CancellationError() }
            ),
            query: "running"
        )

        await viewModel.search()

        // A cancelled search must not masquerade as a user-facing error; the
        // surface is left untouched rather than flipped to `.error`.
        #expect(viewModel.viewState == .initial)
    }

    @Test("retry after a genres/history failure resets to initial and re-fetches")
    @MainActor
    func retryAfterGenresFailureRefetchesAndSucceeds() async {
        let callCount = Mutex(0)
        let viewModel = MediaSearchViewModelTests.makeViewModel(
            dependencies: MediaSearchViewModelTests.stubDependencies(
                fetchGenres: {
                    let isFirstCall = callCount.withLock { count in
                        let wasZero = count == 0
                        count += 1
                        return wasZero
                    }
                    if isFirstCall {
                        throw TestError.generic
                    }
                    return MediaSearchViewModelTests.testGenres
                }
            )
        )
        await viewModel.fetchGenresAndSearchHistory()
        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))

        // Poll for the exact populated snapshot, not just the `.genres` case: the
        // loader synchronously derives a transient `.genres(empty)` surface before
        // its async fetch resolves (see `fetchGenresAndSearchHistory()`), which a
        // looser case-only predicate would catch prematurely.
        let expectedState = MediaSearchViewModel.ViewState.genres(
            MediaSearchViewModel.GenresViewSnapshot(genres: MediaSearchViewModelTests.testGenres)
        )
        viewModel.retry()
        await MediaSearchViewModelTests.waitUntil { viewModel.viewState == expectedState }

        #expect(viewModel.viewState == expectedState)
    }

    @Test("retry after a search failure re-runs the search and succeeds")
    @MainActor
    func retryAfterSearchFailureRefetchesAndSucceeds() async {
        let callCount = Mutex(0)
        let viewModel = MediaSearchViewModelTests.makeViewModel(
            dependencies: MediaSearchViewModelTests.stubDependencies(
                search: { _ in
                    let isFirstCall = callCount.withLock { count in
                        let wasZero = count == 0
                        count += 1
                        return wasZero
                    }
                    if isFirstCall {
                        throw TestError.generic
                    }
                    return MediaSearchViewModelTests.testResults
                }
            ),
            query: "running"
        )
        await viewModel.search()
        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))

        viewModel.retry()
        await MediaSearchViewModelTests.waitUntil { viewModel.viewState.isSearchResults }

        #expect(
            viewModel.viewState == .searchResults(
                MediaSearchViewModel.SearchResultsViewSnapshot(
                    query: "running",
                    results: MediaSearchViewModelTests.testResults
                )
            )
        )
    }

    @Test("retry re-runs the loader that failed, not the one the current query implies")
    @MainActor
    func retryTargetsFailedLoaderNotCurrentQuery() async {
        let genresCallCount = Mutex(0)
        let searchCallCount = Mutex(0)
        let viewModel = MediaSearchViewModelTests.makeViewModel(
            dependencies: MediaSearchViewModelTests.stubDependencies(
                fetchGenres: {
                    let isFirstCall = genresCallCount.withLock { count in
                        let wasZero = count == 0
                        count += 1
                        return wasZero
                    }
                    if isFirstCall {
                        throw TestError.generic
                    }
                    return MediaSearchViewModelTests.testGenres
                },
                search: { _ in
                    searchCallCount.withLock { $0 += 1 }
                    return MediaSearchViewModelTests.testResults
                }
            )
        )

        // Genres/history load fails while the query is still empty.
        await viewModel.fetchGenresAndSearchHistory()
        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))

        // The `.searchable` field stays live during loading, so by the time Retry
        // is tapped the query has gone non-empty — but the failure was in the
        // genres/history loader, so that is what must re-run (never `search()`).
        viewModel.query = "running"
        viewModel.retry()

        await MediaSearchViewModelTests.waitUntil { genresCallCount.withLock { $0 } == 2 }

        #expect(genresCallCount.withLock { $0 } == 2)
        #expect(searchCallCount.withLock { $0 } == 0)
    }

}
