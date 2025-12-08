//
//  MediaSearchFeature.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MediaSearchFeature: Sendable {

    @Dependency(\.mediaSearch) private var mediaSearch: MediaSearchClient

    @ObservableState
    public struct State {

        public enum Field: String, Hashable {
            case search
        }

        public enum Content: Equatable {
            case overview
            case searchHistory
            case searchResults([MediaPreview])
            case noSearchResults(String)
        }

        var content: Content
        var query: String
        var searchHistoryItems: [MediaPreview]
        var focusedField: Field?

        public init(
            content: Content = .overview,
            query: String = "",
            searchHistoryItems: [MediaPreview] = [],
            focusedField: Field? = nil
        ) {
            self.content = content
            self.query = query
            self.searchHistoryItems = searchHistoryItems
            self.focusedField = focusedField
        }
    }

    public enum Action {
        case loadSearchHistory
        case searchHistoryLoaded([MediaPreview])
        case queryChanged(String)
        case performSearch
        case searchResultsLoaded(query: String, results: [MediaPreview])
        case focusChanged(State.Field?)
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
            case .loadSearchHistory:
                effect = handleLoadSearchHistory(state: &state)

            case .searchHistoryLoaded(let items):
                state.searchHistoryItems = items
                effect = .none

            case .queryChanged(let query):
                state.query = query
                if query.isEmpty {
                    effect = .cancel(id: CancelID.search)
                } else {
                    effect = .run { send in
                        await send(.performSearch)
                    }
                    .debounce(
                        id: CancelID.search,
                        for: .milliseconds(300),
                        scheduler: DispatchQueue.main
                    )
                }

            case .performSearch:
                effect = handlePerformSearch(state: &state)

            case .searchResultsLoaded(let query, let results):
                if results.isEmpty {
                    state.content = .noSearchResults(query)
                } else {
                    state.content = .searchResults(results)
                }
                effect = .none

            case .focusChanged(let field):
                state.focusedField = field
                effect = .none

            case .navigate(.movieDetails(let movieID)):
                effect = handleAddMovieSearchHistoryEntry(movieID: movieID)

            case .navigate(.tvSeriesDetails(let tvSeriesID)):
                effect = handleAddTVSeriesSearchHistoryEntry(tvSeriesID: tvSeriesID)

            case .navigate(.personDetails(let personID)):
                effect = handleAddPersonSearchHistoryEntry(personID: personID)
            }

            updateContent(state: &state)
            return effect
        }
    }

}

extension MediaSearchFeature {

    private func updateContent(state: inout State) {
        let hasResultsOrOutcome: Bool
        switch state.content {
        case .searchResults, .noSearchResults:
            hasResultsOrOutcome = true
        default:
            hasResultsOrOutcome = false
        }

        if state.query.isEmpty {
            if state.focusedField == .search {
                state.content = .searchHistory
            } else {
                state.content = .overview
            }
            return
        }

        if state.focusedField == .search && hasResultsOrOutcome == false {
            state.content = .searchHistory
            return
        }
    }

    private func handleLoadSearchHistory(state: inout State) -> EffectOf<Self> {
        .run { send in
            let items = try await mediaSearch.fetchMediaSearchHistory()
            await send(.searchHistoryLoaded(items))
        }
    }

    private func handlePerformSearch(state: inout State) -> EffectOf<Self> {
        let query = state.query
        return .run { send in
            let results = try await mediaSearch.search(query)
            await send(.searchResultsLoaded(query: query, results: results))
        }
    }

    private func handleAddMovieSearchHistoryEntry(movieID: Int) -> EffectOf<Self> {
        .run { _ in
            try await mediaSearch.addMovieSearchHistoryEntry(movieID)
        }
    }

    private func handleAddTVSeriesSearchHistoryEntry(tvSeriesID: Int) -> EffectOf<Self> {
        .run { _ in
            try await mediaSearch.addTVSeriesSearchHistoryEntry(tvSeriesID)
        }
    }

    private func handleAddPersonSearchHistoryEntry(personID: Int) -> EffectOf<Self> {
        .run { _ in
            try await mediaSearch.addPersonSearchHistoryEntry(personID)
        }
    }

}
