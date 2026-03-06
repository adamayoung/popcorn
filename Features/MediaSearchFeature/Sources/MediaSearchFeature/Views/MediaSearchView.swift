//
//  MediaSearchView.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import SwiftUI

public struct MediaSearchView: View {

    @Bindable private var store: StoreOf<MediaSearchFeature>
    @FocusState private var focusedField: MediaSearchFeature.Field?

    public init(store: StoreOf<MediaSearchFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .genres(let snapshot):
                MediaSearchGenresContentView(genres: snapshot.genres) { genre in
                    store.send(.navigate(.genre(id: genre.id)))
                }

            case .searchHistory(let snapshot):
                MediaSearchHistoryContentView(
                    media: snapshot.media,
                    onMovieTapped: { store.send(.navigate(.movieDetails(id: $0.id))) },
                    onTVSeriesTapped: { store.send(.navigate(.tvSeriesDetails(id: $0.id))) },
                    onPersonTapped: { store.send(.navigate(.personDetails(id: $0.id))) }
                )

            case .searchResults(let snapshot):
                MediaSearchResultsContentView(
                    results: snapshot.results,
                    onMovieTapped: { store.send(.navigate(.movieDetails(id: $0.id))) },
                    onTVSeriesTapped: { store.send(.navigate(.tvSeriesDetails(id: $0.id))) },
                    onPersonTapped: { store.send(.navigate(.personDetails(id: $0.id))) }
                )

            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("media-search.view")
        .overlay {
            if case .noSearchResults(let snapshot) = store.viewState {
                ContentUnavailableView(
                    LocalizedStringResource("NO_RESULTS", bundle: .module),
                    systemImage: "magnifyingglass",
                    description: Text("NO_RESULTS_FOR_\(snapshot.query)_TRY_AGAIN", bundle: .module)
                )
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .searchable(
            text: $store.query.sending(\.queryChanged),
            //            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("MOVIES_TV_OR_PEOPLE", bundle: .module)
        )
        .searchFocused($focusedField, equals: .search)
        .bind($store.focusedField.sending(\.focusChanged), to: $focusedField)
        .task { store.send(.fetchGenresAndSearchHistory) }
        .navigationTitle(Text("SEARCH", bundle: .module))
    }

}

#Preview("Genres") {
    TabView {
        Tab(
            "SEARCH",
            systemImage: "magnifyingglass",
            role: .search
        ) {
            NavigationStack {
                MediaSearchView(
                    store: Store(
                        initialState: MediaSearchFeature.State(
                            viewState: .genres(.init(genres: Genre.mocks))
                        ),
                        reducer: {
                            EmptyReducer()
                        }
                    )
                )
            }
        }
    }
}

#Preview("Search History") {
    TabView {
        Tab(
            "SEARCH",
            systemImage: "magnifyingglass",
            role: .search
        ) {
            NavigationStack {
                MediaSearchView(
                    store: Store(
                        initialState: MediaSearchFeature.State(
                            viewState: .searchHistory(.init(media: MediaPreview.mocks))
                        ),
                        reducer: {
                            EmptyReducer()
                        }
                    )
                )
            }
        }
    }
}

#Preview("Search Results") {
    TabView {
        Tab(
            "SEARCH",
            systemImage: "magnifyingglass",
            role: .search
        ) {
            NavigationStack {
                MediaSearchView(
                    store: Store(
                        initialState: MediaSearchFeature.State(
                            viewState: .searchResults(
                                .init(
                                    query: "running",
                                    results: MediaPreview.mocks
                                )
                            ),
                            query: "running"
                        ),
                        reducer: {
                            EmptyReducer()
                        }
                    )
                )
            }
        }
    }
}

#Preview("No Search Results") {
    TabView {
        Tab(
            "SEARCH",
            systemImage: "magnifyingglass",
            role: .search
        ) {
            NavigationStack {
                MediaSearchView(
                    store: Store(
                        initialState: MediaSearchFeature.State(
                            viewState: .noSearchResults(
                                .init(
                                    query: "running"
                                )
                            ),
                            query: "running"
                        ),
                        reducer: {
                            EmptyReducer()
                        }
                    )
                )
            }
        }
    }
}
