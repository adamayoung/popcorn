//
//  MediaSearchViewModel.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observation
import OSLog
import Presentation

/// Drives ``MediaSearchView``. The MVVM replacement for `MediaSearchFeature`.
///
/// Keeps the feature's bespoke ``ViewState`` enum (genres / search history /
/// results / no results) rather than the generic `Presentation.ViewState<T>`,
/// because the empty-query / focus interplay drives several distinct surfaces.
///
/// `updateViewState()` is invoked after every state-mutating method, exactly as
/// the former reducer called it on the tail of every `Reduce`. The debounced
/// search is owned by a single ``searchTask`` so a rapid second keystroke cancels
/// the first in-flight debounce — the MVVM replacement for the reducer's
/// `.cancellable(id:cancelInFlight:)`.
@Observable
@MainActor
public final class MediaSearchViewModel {

    private static let logger = Logger.mediaSearch

    public enum Field: String, Hashable, Sendable {
        case search
    }

    public enum ViewState: Equatable, Sendable {
        case initial
        case loading
        case genres(GenresViewSnapshot)
        case searchHistory(SearchHistoryViewSnapshot)
        case searchResults(SearchResultsViewSnapshot)
        case noSearchResults(NoSearchResultsViewSnapshot)
        case error(ViewStateError)
    }

    public struct GenresViewSnapshot: Equatable, Sendable {
        public let genres: [Genre]

        public init(genres: [Genre] = []) {
            self.genres = genres
        }
    }

    public struct SearchHistoryViewSnapshot: Equatable, Sendable {
        public let media: [MediaPreview]

        public init(media: [MediaPreview] = []) {
            self.media = media
        }
    }

    public struct SearchResultsViewSnapshot: Equatable, Sendable {
        public let query: String
        public let results: [MediaPreview]

        public init(query: String = "", results: [MediaPreview] = []) {
            self.query = query
            self.results = results
        }
    }

    public struct NoSearchResultsViewSnapshot: Equatable, Sendable {
        public let query: String

        public init(query: String = "") {
            self.query = query
        }
    }

    public private(set) var viewState: ViewState
    public var query: String
    public private(set) var focusedField: Field?

    private var genresSnapshot = GenresViewSnapshot()
    private var searchHistorySnapshot = SearchHistoryViewSnapshot()

    private let dependencies: MediaSearchDependencies
    private let navigator: any MediaSearchNavigating

    /// The debounce interval (ms) before a `queryChanged` triggers a search.
    /// Injectable so tests can pass `0` for deterministic, immediate searches.
    private let debounceInterval: Int

    /// The single in-flight debounce + search task. A new `queryChanged` cancels
    /// it before starting another, replicating `cancelInFlight: true`.
    private var searchTask: Task<Void, Never>?

    public init(
        dependencies: MediaSearchDependencies,
        navigator: any MediaSearchNavigating,
        viewState: ViewState = .initial,
        query: String = "",
        focusedField: Field? = nil,
        debounceInterval: Int = 300
    ) {
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
        self.query = query
        self.focusedField = focusedField
        self.debounceInterval = debounceInterval
    }

    // MARK: - Lifecycle

    /// Fetches genres and search history, then derives the initial surface.
    ///
    /// Drive this from the view's `.task`; SwiftUI cancels it on disappear. A
    /// no-op unless the view state is `.initial`, mirroring the former reducer's
    /// `guard case .initial` on `fetchGenresAndSearchHistory`.
    public func fetchGenresAndSearchHistory() async {
        // Tail-`updateViewState` after every former reducer action is replicated
        // here so the surface stays identical even if the field is focused mid-load.
        guard case .initial = viewState else {
            return
        }

        viewState = .loading
        // Former `fetchGenresAndSearchHistory` action tail: with an empty,
        // unfocused query this immediately derives `.genres(empty)`.
        updateViewState()

        Self.logger.info("User fetching genres and search history")

        let genres: [Genre]
        let searchHistoryMedia: [MediaPreview]
        do {
            async let genresTask = dependencies.fetchGenres()
            async let historyTask = dependencies.fetchMediaSearchHistory()
            genres = try await genresTask
            searchHistoryMedia = try await historyTask
        } catch {
            Self.logger.error(
                "Failed fetching genres and search history: \(error.localizedDescription, privacy: .public)"
            )
            // Former `genresAndSearchHistoryLoadFailed` action tail.
            updateViewState()
            return
        }

        // Former `genresAndSearchHistoryLoaded` action: store snapshots, promote
        // `.loading`, then re-derive the surface from the current query / focus.
        genresSnapshot = GenresViewSnapshot(genres: genres)
        searchHistorySnapshot = SearchHistoryViewSnapshot(media: searchHistoryMedia)
        if case .loading = viewState {
            viewState = .genres(genresSnapshot)
        }
        updateViewState()
    }

    // MARK: - Input

    /// Updates the query and (de)bounces a search. An empty query cancels any
    /// in-flight search; a non-empty query schedules one after ``debounceInterval``.
    /// Mirrors the former reducer's `queryChanged` effect.
    public func queryChanged(_ query: String) {
        self.query = query

        if query.isEmpty {
            searchTask?.cancel()
            searchTask = nil
            updateViewState()
            return
        }

        searchTask?.cancel()
        searchTask = Task { [weak self, debounceInterval] in
            try? await Task.sleep(for: .milliseconds(debounceInterval))
            guard !Task.isCancelled else {
                return
            }
            await self?.search()
        }

        updateViewState()
    }

    /// Records the focused field and recomputes the surface. Mirrors the former
    /// reducer's `focusChanged`.
    public func focusChanged(_ field: Field?) {
        focusedField = field
        updateViewState()
    }

    // MARK: - Search

    /// Performs a media search for the current ``query``. Mirrors the former
    /// reducer's `search` effect: results, no-results, or a logged failure.
    public func search() async {
        Self.logger.info(
            "User searching for media [query: \"\(self.query, privacy: .private)\"]"
        )

        let results: [MediaPreview]
        do {
            results = try await dependencies.search(query)
        } catch {
            Self.logger.error(
                "Failed searching for media [query: \"\(self.query, privacy: .private)\"]: \(error.localizedDescription, privacy: .public)"
            )
            // Former `searchResultsLoadFailed` action tail: re-derive the surface.
            updateViewState()
            return
        }

        if results.isEmpty {
            viewState = .noSearchResults(NoSearchResultsViewSnapshot(query: query))
        } else {
            viewState = .searchResults(SearchResultsViewSnapshot(query: query, results: results))
        }

        updateViewState()
    }

    // MARK: - Navigation

    public func selectMovie(id: Int) {
        addMovieSearchHistoryEntry(movieID: id)
        navigator.openMovieDetails(id: id)
    }

    public func selectTVSeries(id: Int) {
        addTVSeriesSearchHistoryEntry(tvSeriesID: id)
        navigator.openTVSeriesDetails(id: id)
    }

    public func selectPerson(id: Int) {
        addPersonSearchHistoryEntry(personID: id)
        navigator.openPersonDetails(id: id)
    }

}

extension MediaSearchViewModel {

    /// Re-derives the surface from `query` + `focusedField`. Ported verbatim from
    /// the former reducer's `updateViewState(state:)`:
    /// - empty query + focused → search history
    /// - empty query + unfocused → genres
    /// - non-empty query + focused + no results yet → search history
    /// - otherwise leave the current surface untouched
    private func updateViewState() {
        let hasResultsOrOutcome = switch viewState {
        case .searchResults, .noSearchResults:
            true
        default:
            false
        }

        if query.isEmpty {
            if focusedField == .search {
                viewState = .searchHistory(searchHistorySnapshot)
            } else {
                viewState = .genres(genresSnapshot)
            }
            return
        }

        if focusedField == .search, hasResultsOrOutcome == false {
            viewState = .searchHistory(searchHistorySnapshot)
            return
        }
    }

    private func addMovieSearchHistoryEntry(movieID: Int) {
        Task { [dependencies] in
            Self.logger.info(
                "Adding movie to search history [movieID: \"\(movieID, privacy: .private)\"]"
            )
            do {
                try await dependencies.addMovieSearchHistoryEntry(movieID)
            } catch {
                Self.logger.error(
                    "Failed adding movie to search history [movieID: \"\(movieID, privacy: .private)\"]: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

    private func addTVSeriesSearchHistoryEntry(tvSeriesID: Int) {
        Task { [dependencies] in
            Self.logger.info(
                "Adding TV series to search history [tvSeriesID: \"\(tvSeriesID, privacy: .private)\"]"
            )
            do {
                try await dependencies.addTVSeriesSearchHistoryEntry(tvSeriesID)
            } catch {
                Self.logger.error(
                    "Failed adding TV series to search history [tvSeriesID: \"\(tvSeriesID, privacy: .private)\"]: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

    private func addPersonSearchHistoryEntry(personID: Int) {
        Task { [dependencies] in
            Self.logger.info(
                "Adding person to search history [personID: \"\(personID, privacy: .private)\"]"
            )
            do {
                try await dependencies.addPersonSearchHistoryEntry(personID)
            } catch {
                Self.logger.error(
                    "Failed adding person to search history [personID: \"\(personID, privacy: .private)\"]: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

}

#if DEBUG
    public extension MediaSearchViewModel {

        /// A view model pinned to a fixed view state with mock dependencies and
        /// a no-op navigator, for previews and snapshot tests.
        static func preview(
            viewState: ViewState,
            query: String = "",
            focusedField: Field? = nil
        ) -> MediaSearchViewModel {
            MediaSearchViewModel(
                dependencies: .preview,
                navigator: NoOpMediaSearchNavigator(),
                viewState: viewState,
                query: query,
                focusedField: focusedField
            )
        }

    }
#endif
