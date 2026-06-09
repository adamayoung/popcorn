//
//  MediaSearchViewModelTests.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import MediaSearchFeature
import Synchronization
import Testing

@Suite("MediaSearchViewModel Tests")
struct MediaSearchViewModelTests {

    // MARK: - fetchGenresAndSearchHistory

    @Test("fetchGenresAndSearchHistory loads genres and shows the genres surface")
    @MainActor
    func fetchLoadsGenresSurface() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchGenres: { Self.testGenres },
                fetchMediaSearchHistory: { Self.testHistory }
            )
        )

        await viewModel.fetchGenresAndSearchHistory()

        #expect(
            viewModel.viewState == .genres(
                MediaSearchViewModel.GenresViewSnapshot(genres: Self.testGenres)
            )
        )
    }

    @Test("fetchGenresAndSearchHistory is a no-op when not initial")
    @MainActor
    func fetchNoOpWhenNotInitial() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchGenres: { fetchCalled.withLock { $0 = true }; return Self.testGenres }
            ),
            viewState: .genres(.init(genres: Self.testGenres))
        )

        await viewModel.fetchGenresAndSearchHistory()

        #expect(fetchCalled.withLock { $0 } == false)
    }

    @Test("fetchGenresAndSearchHistory failure logs and derives empty genres (unfocused)")
    @MainActor
    func fetchFailureDerivesEmptyGenres() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchGenres: { throw TestError.generic }
            )
        )

        await viewModel.fetchGenresAndSearchHistory()

        // Mirrors the former reducer: the load-failed action's tail `updateViewState`
        // re-derives the surface — empty query + unfocused → empty genres.
        #expect(
            viewModel.viewState == .genres(MediaSearchViewModel.GenresViewSnapshot())
        )
    }

    // MARK: - queryChanged / debounce

    @Test("queryChanged debounces then applies search results")
    @MainActor
    func queryChangedAppliesResults() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                search: { _ in Self.testResults }
            ),
            debounceInterval: 0
        )

        viewModel.queryChanged("running")
        await Self.waitUntil { viewModel.viewState.isSearchResults }

        #expect(
            viewModel.viewState == .searchResults(
                MediaSearchViewModel.SearchResultsViewSnapshot(
                    query: "running",
                    results: Self.testResults
                )
            )
        )
    }

    @Test("queryChanged with no results applies the no-results surface")
    @MainActor
    func queryChangedNoResults() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(search: { _ in [] }),
            debounceInterval: 0
        )

        viewModel.queryChanged("zzz")
        await Self.waitUntil { viewModel.viewState.isNoSearchResults }

        #expect(
            viewModel.viewState == .noSearchResults(
                MediaSearchViewModel.NoSearchResultsViewSnapshot(query: "zzz")
            )
        )
    }

    @Test("a rapid second queryChanged cancels the first in-flight debounce")
    @MainActor
    func queryChangedCancelsInFlight() async {
        let searchedQueries = Mutex<[String]>([])
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                search: { query in
                    searchedQueries.withLock { $0.append(query) }
                    return Self.testResults
                }
            ),
            debounceInterval: 0
        )

        // Both calls run synchronously before either spawned Task body executes,
        // so the first debounce Task is cancelled when the second replaces it.
        viewModel.queryChanged("ru")
        viewModel.queryChanged("running")

        await Self.waitUntil { viewModel.viewState.isSearchResults }

        #expect(searchedQueries.withLock { $0 } == ["running"])
    }

    @Test("emptying the query cancels search and shows genres when unfocused")
    @MainActor
    func emptyQueryCancelsAndShowsGenres() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(),
            viewState: .searchResults(.init(query: "x", results: Self.testResults)),
            query: "x"
        )

        viewModel.queryChanged("")

        #expect(
            viewModel.viewState == .genres(MediaSearchViewModel.GenresViewSnapshot())
        )
    }

    // MARK: - focusChanged / updateViewState

    @Test("focusChanged to search with empty query shows search history")
    @MainActor
    func focusShowsSearchHistory() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchMediaSearchHistory: { Self.testHistory })
        )
        await viewModel.fetchGenresAndSearchHistory()

        viewModel.focusChanged(.search)

        #expect(
            viewModel.viewState == .searchHistory(
                MediaSearchViewModel.SearchHistoryViewSnapshot(media: Self.testHistory)
            )
        )
    }

    @Test("losing focus with empty query returns to genres")
    @MainActor
    func unfocusReturnsToGenres() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchGenres: { Self.testGenres },
                fetchMediaSearchHistory: { Self.testHistory }
            )
        )
        await viewModel.fetchGenresAndSearchHistory()
        viewModel.focusChanged(.search)

        viewModel.focusChanged(nil)

        #expect(
            viewModel.viewState == .genres(
                MediaSearchViewModel.GenresViewSnapshot(genres: Self.testGenres)
            )
        )
    }

    @Test("non-empty query while focused with no results yet shows search history")
    @MainActor
    func focusedNonEmptyNoResultsShowsHistory() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchMediaSearchHistory: { Self.testHistory }),
            debounceInterval: 0
        )
        await viewModel.fetchGenresAndSearchHistory()
        viewModel.focusChanged(.search)

        // query set, but no search outcome applied yet (debounce hasn't fired).
        viewModel.query = "ru"
        viewModel.focusChanged(.search)

        #expect(
            viewModel.viewState == .searchHistory(
                MediaSearchViewModel.SearchHistoryViewSnapshot(media: Self.testHistory)
            )
        )
    }

    // MARK: - Navigation

    @Test("selectMovie invokes the navigator")
    @MainActor
    func selectMovieNavigates() {
        let navigator = SpyMediaSearchNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectMovie(id: 11)

        #expect(navigator.openedMovieID == 11)
    }

    @Test("selectTVSeries invokes the navigator")
    @MainActor
    func selectTVSeriesNavigates() {
        let navigator = SpyMediaSearchNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectTVSeries(id: 22)

        #expect(navigator.openedTVSeriesID == 22)
    }

    @Test("selectPerson invokes the navigator")
    @MainActor
    func selectPersonNavigates() {
        let navigator = SpyMediaSearchNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectPerson(id: 33)

        #expect(navigator.openedPersonID == 33)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyMediaSearchNavigator: MediaSearchNavigating {
    var openedMovieID: Int?
    var openedTVSeriesID: Int?
    var openedPersonID: Int?

    func openMovieDetails(id: Int) {
        openedMovieID = id
    }

    func openTVSeriesDetails(id: Int) {
        openedTVSeriesID = id
    }

    func openPersonDetails(id: Int) {
        openedPersonID = id
    }
}

// MARK: - ViewState Test Conveniences

private extension MediaSearchViewModel.ViewState {

    var isSearchResults: Bool {
        if case .searchResults = self {
            return true
        }
        return false
    }

    var isNoSearchResults: Bool {
        if case .noSearchResults = self {
            return true
        }
        return false
    }

}

// MARK: - Factories

extension MediaSearchViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: MediaSearchDependencies = stubDependencies(),
        navigator: any MediaSearchNavigating = SpyMediaSearchNavigator(),
        viewState: MediaSearchViewModel.ViewState = .initial,
        query: String = "",
        focusedField: MediaSearchViewModel.Field? = nil,
        debounceInterval: Int = 0
    ) -> MediaSearchViewModel {
        MediaSearchViewModel(
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
            query: query,
            focusedField: focusedField,
            debounceInterval: debounceInterval
        )
    }

    static func stubDependencies(
        fetchGenres: @escaping @Sendable () async throws -> [Genre] = { testGenres },
        search: @escaping @Sendable (String) async throws -> [MediaPreview] = { _ in testResults },
        fetchMediaSearchHistory: @escaping @Sendable () async throws -> [MediaPreview] = { testHistory },
        addMovieSearchHistoryEntry: @escaping @Sendable (Int) async throws -> Void = { _ in },
        addTVSeriesSearchHistoryEntry: @escaping @Sendable (Int) async throws -> Void = { _ in },
        addPersonSearchHistoryEntry: @escaping @Sendable (Int) async throws -> Void = { _ in }
    ) -> MediaSearchDependencies {
        MediaSearchDependencies(
            fetchGenres: fetchGenres,
            search: search,
            fetchMediaSearchHistory: fetchMediaSearchHistory,
            addMovieSearchHistoryEntry: addMovieSearchHistoryEntry,
            addTVSeriesSearchHistoryEntry: addTVSeriesSearchHistoryEntry,
            addPersonSearchHistoryEntry: addPersonSearchHistoryEntry
        )
    }

    /// Polls `predicate` on the main actor, yielding between checks, until it holds
    /// or a bounded number of iterations elapse. Drives the spawned debounce/search
    /// `Task` to completion without sleeping on wall-clock time.
    @MainActor
    static func waitUntil(
        iterations: Int = 1000,
        _ predicate: () -> Bool
    ) async {
        for _ in 0 ..< iterations {
            if predicate() {
                return
            }
            await Task.yield()
        }
    }

}

// MARK: - Test Data

extension MediaSearchViewModelTests {

    static let testGenres = [
        Genre(id: 1, name: "Action", color: ThemeColor(red: 1, green: 0, blue: 0)),
        Genre(id: 2, name: "Comedy", color: ThemeColor(red: 0, green: 1, blue: 0))
    ]

    static let testHistory: [MediaPreview] = [
        .movie(MoviePreview(id: 10, title: "History Movie"))
    ]

    static let testResults: [MediaPreview] = [
        .movie(MoviePreview(id: 20, title: "Result Movie")),
        .tvSeries(TVSeriesPreview(id: 21, name: "Result Series"))
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
