//
//  MediaSearchView.swift
//  MediaSearchFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MediaSearchView: View {

    @Bindable private var store: StoreOf<MediaSearchFeature>
    @FocusState private var focusedField: MediaSearchFeature.Field?

    public init(store: StoreOf<MediaSearchFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        List {
            switch store.viewState {
            case .genres(let snapshot):
                genresContent(snapshot.genres)

            case .searchHistory(let snapshot):
                searchHistoryContent(snapshot.media)

            case .searchResults(let snapshot):
                searchResultsContent(snapshot.results)

            default:
                EmptyView()
            }
        }
        .overlay {
            if case .noSearchResults(let snapshot) = store.viewState {
                noSearchResultsContent(snapshot.query)
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

    private func genresContent(_ genres: [Genre]) -> some View {
        Section {
            Text("Genres...")
        }
    }

    private func searchHistoryContent(_ media: [MediaPreview]) -> some View {
        Section {
            ForEach(media) { media in
                mediaRow(for: media)
            }
        } header: {
            Text("RECENTLY_SEARCHED", bundle: .module)
        }
    }

    private func searchResultsContent(_ results: [MediaPreview]) -> some View {
        Section {
            ForEach(results) { media in
                mediaRow(for: media)
            }
        }
    }

    private func noSearchResultsContent(_ query: String) -> some View {
        ContentUnavailableView(
            LocalizedStringResource("NO_RESULTS", bundle: .module),
            systemImage: "magnifyingglass",
            description: Text("NO_RESULTS_FOR_\(query)_TRY_AGAIN", bundle: .module)
        )
    }

}

extension MediaSearchView {

    @ViewBuilder
    private func mediaRow(for media: MediaPreview) -> some View {
        switch media {
        case .movie(let movie):
            movieRow(for: movie)
        case .tvSeries(let tvSeries):
            tvSeriesRow(for: tvSeries)
        case .person(let person):
            personRow(for: person)
        }
    }

    private func movieRow(for movie: MoviePreview) -> some View {
        Button {
            store.send(.navigate(.movieDetails(id: movie.id)))
        } label: {
            HStack {
                PosterImage(url: movie.posterURL)
                    .posterWidth(60)
                    .cornerRadius(5)
                    .clipped()

                Text(verbatim: movie.title)
            }
        }
        .buttonStyle(.plain)
    }

    private func tvSeriesRow(for tvSeries: TVSeriesPreview) -> some View {
        Button {
            store.send(.navigate(.tvSeriesDetails(id: tvSeries.id)))
        } label: {
            HStack {
                PosterImage(url: tvSeries.posterURL)
                    .posterWidth(60)
                    .cornerRadius(5)
                    .clipped()

                Text(verbatim: tvSeries.name)
            }
        }
        .buttonStyle(.plain)
    }

    private func personRow(for person: PersonPreview) -> some View {
        Button {
            store.send(.navigate(.personDetails(id: person.id)))
        } label: {
            HStack {
                ProfileImage(url: person.profileURL)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                Text(verbatim: person.name)
            }
        }
        .buttonStyle(.plain)
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
