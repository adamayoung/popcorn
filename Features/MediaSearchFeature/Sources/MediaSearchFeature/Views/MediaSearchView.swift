//
//  MediaSearchView.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MediaSearchView: View {

    @Bindable private var store: StoreOf<MediaSearchFeature>
    @FocusState private var focusedField: MediaSearchFeature.State.Field?

    public init(store: StoreOf<MediaSearchFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        List {
            switch store.content {
            case .overview:
                notSearchingContent

            case .searchHistory:
                searchHistoryContent

            case .searchResults(let results):
                resultsContent(results)

            default:
                EmptyView()
            }
        }
        .overlay {
            if case .noSearchResults(let query) = store.content {
                noResultsContent(query)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .searchable(
            text: $store.query.sending(\.queryChanged),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("MOVIES_TV_OR_PEOPLE", bundle: .module)
        )
        .searchFocused($focusedField, equals: .search)
        .bind($store.focusedField.sending(\.focusChanged), to: self.$focusedField)
        .task { store.send(.loadSearchHistory) }
        .navigationTitle(Text("SEARCH", bundle: .module))
    }

    @ViewBuilder
    private var notSearchingContent: some View {

    }

    @ViewBuilder
    private var searchHistoryContent: some View {
        Section {
            ForEach(store.searchHistoryItems) { media in
                mediaRow(for: media)
            }
        } header: {
            Text("RECENTLY_SEARCHED", bundle: .module)
        }
    }

    @ViewBuilder
    private func resultsContent(_ results: [MediaPreview]) -> some View {
        Section {
            ForEach(results) { media in
                mediaRow(for: media)
            }
        }
    }

    @ViewBuilder
    private func noResultsContent(_ query: String) -> some View {
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
        NavigationRow {
            store.send(.navigate(.personDetails(id: person.id)))
        } content: {
            HStack {
                ProfileImage(url: person.profileURL)
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
                    .clipped()

                Text(verbatim: person.name)
            }
        }
    }

}

#Preview("Overview") {
    NavigationStack {
        MediaSearchView(
            store: Store(
                initialState: MediaSearchFeature.State(
                    content: .overview
                ),
                reducer: {
                    EmptyReducer()
                }
            )
        )
    }
}

#Preview("Overview") {
    NavigationStack {
        MediaSearchView(
            store: Store(
                initialState: MediaSearchFeature.State(
                    content: .searchHistory,
                    searchHistoryItems: MediaPreview.mocks
                ),
                reducer: {
                    EmptyReducer()
                }
            )
        )
    }
}
