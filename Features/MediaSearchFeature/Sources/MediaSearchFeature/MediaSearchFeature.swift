//
//  MediaSearchFeature.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct MediaSearchFeature: Sendable {

    private static let logger = Logger(
        subsystem: "MediaSearchFeature",
        category: "MediaSearchFeatureReducer"
    )

    @Dependency(\.mediaSearchClient) private var mediaSearchClient

    @ObservableState
    public struct State: Sendable {

        var viewState: ViewState
        var query: String
        var focusedField: Field?

        fileprivate var genresSnapshot = GenresViewSnapshot()
        fileprivate var searchHistorySnapshot = SearchHistoryViewSnapshot()

        public init(
            viewState: ViewState = .initial,
            query: String = "",
            focusedField: Field? = nil
        ) {
            self.viewState = viewState
            self.query = query
            self.focusedField = focusedField
        }
    }

    public enum Field: String, Hashable, Sendable {
        case search
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case genres(GenresViewSnapshot)
        case searchHistory(SearchHistoryViewSnapshot)
        case searchResults(SearchResultsViewSnapshot)
        case noSearchResults(NoSearchResultsViewSnapshot)
        case error(Error)
    }

    public struct GenresViewSnapshot: Sendable {
        public let genres: [Genre]

        public init(genres: [Genre] = []) {
            self.genres = genres
        }
    }

    public struct SearchHistoryViewSnapshot: Sendable {
        public let media: [MediaPreview]

        public init(media: [MediaPreview] = []) {
            self.media = media
        }
    }

    public struct SearchResultsViewSnapshot: Sendable {
        public let query: String
        public let results: [MediaPreview]

        public init(query: String = "", results: [MediaPreview] = []) {
            self.query = query
            self.results = results
        }
    }

    public struct NoSearchResultsViewSnapshot: Sendable {
        public let query: String

        public init(query: String = "") {
            self.query = query
        }
    }

    public enum Action {
        case fetchGenresAndSearchHistory
        case genresAndSearchHistoryLoaded(GenresViewSnapshot, SearchHistoryViewSnapshot)
        case genresAndSearchHistoryLoadFailed(Error)

        case queryChanged(String)
        case focusChanged(Field?)

        case search
        case searchResultsLoaded(SearchResultsViewSnapshot)
        case searchWithNoResultsLoaded(NoSearchResultsViewSnapshot)
        case searchResultsLoadFailed(Error)

        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int)
        case tvSeriesDetails(id: Int)
        case personDetails(id: Int)
    }

    private enum CancelID { case search }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            let effect: EffectOf<Self>
            switch action {
            case .fetchGenresAndSearchHistory:
                guard case .initial = state.viewState else {
                    effect = .none
                    break
                }

                state.viewState = .loading
                effect = handleFetchGenresAndSearchHistory()
            case .genresAndSearchHistoryLoaded(let genresSnapshot, let searchHistorySnapshot):
                state.genresSnapshot = genresSnapshot
                state.searchHistorySnapshot = searchHistorySnapshot
                if case .loading = state.viewState {
                    state.viewState = .genres(genresSnapshot)
                }
                effect = .none

            case .genresAndSearchHistoryLoadFailed(let error):
                Self.logger.error(
                    "Failed loading genres and search history: \(error.localizedDescription)")
                effect = .none

            case .queryChanged(let query):
                state.query = query
                if query.isEmpty {
                    effect = .cancel(id: CancelID.search)
                } else {
                    effect = .run { send in
                        await send(.search)
                    }
                    .debounce(
                        id: CancelID.search,
                        for: .milliseconds(300),
                        scheduler: DispatchQueue.main
                    )
                }

            case .focusChanged(let field):
                state.focusedField = field
                effect = .none

            case .search:
                effect = handleSearch(state: &state)

            case .searchResultsLoaded(let snapshot):
                state.viewState = .searchResults(snapshot)
                effect = .none

            case .searchWithNoResultsLoaded(let snapshot):
                state.viewState = .noSearchResults(snapshot)
                effect = .none

            case .searchResultsLoadFailed(let error):
                Self.logger.error("Failed searching: \(error.localizedDescription)")
                effect = .none

            case .navigate(.movieDetails(let movieID)):
                effect = handleAddMovieSearchHistoryEntry(movieID: movieID)

            case .navigate(.tvSeriesDetails(let tvSeriesID)):
                effect = handleAddTVSeriesSearchHistoryEntry(tvSeriesID: tvSeriesID)

            case .navigate(.personDetails(let personID)):
                effect = handleAddPersonSearchHistoryEntry(personID: personID)
            }

            updateViewState(state: &state)
            return effect
        }
    }

}

extension MediaSearchFeature {

    private func updateViewState(state: inout State) {
        let hasResultsOrOutcome: Bool
        switch state.viewState {
        case .searchResults, .noSearchResults:
            hasResultsOrOutcome = true
        default:
            hasResultsOrOutcome = false
        }

        if state.query.isEmpty {
            if state.focusedField == .search {
                state.viewState = .searchHistory(state.searchHistorySnapshot)
            } else {
                state.viewState = .genres(state.genresSnapshot)
            }
            return
        }

        if state.focusedField == .search && hasResultsOrOutcome == false {
            state.viewState = .searchHistory(state.searchHistorySnapshot)
            return
        }
    }

    private func handleFetchGenresAndSearchHistory() -> EffectOf<Self> {
        .run { send in
            async let searchHistoryMedia = mediaSearchClient.fetchMediaSearchHistory()

            do {
                let genresSnapshot = GenresViewSnapshot(genres: [])
                let searchHistorySnapshot = try await SearchHistoryViewSnapshot(
                    media: searchHistoryMedia)
                await send(.genresAndSearchHistoryLoaded(genresSnapshot, searchHistorySnapshot))
            } catch let error {
                await send(.genresAndSearchHistoryLoadFailed(error))
            }
        }
    }

    private func handleSearch(state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            let results: [MediaPreview]
            do {
                results = try await mediaSearchClient.search(state.query)
            } catch let error {
                await send(.searchResultsLoadFailed(error))
                return
            }

            if results.isEmpty {
                let snapshot = NoSearchResultsViewSnapshot(query: state.query)
                await send(.searchWithNoResultsLoaded(snapshot))
            } else {
                let snapshot = SearchResultsViewSnapshot(query: state.query, results: results)
                await send(.searchResultsLoaded(snapshot))
            }
        }
    }

    private func handleAddMovieSearchHistoryEntry(movieID: Int) -> EffectOf<Self> {
        .run { _ in
            try await mediaSearchClient.addMovieSearchHistoryEntry(movieID)
        }
    }

    private func handleAddTVSeriesSearchHistoryEntry(tvSeriesID: Int) -> EffectOf<Self> {
        .run { _ in
            try await mediaSearchClient.addTVSeriesSearchHistoryEntry(tvSeriesID)
        }
    }

    private func handleAddPersonSearchHistoryEntry(personID: Int) -> EffectOf<Self> {
        .run { _ in
            try await mediaSearchClient.addPersonSearchHistoryEntry(personID)
        }
    }

}
