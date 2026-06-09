//
//  MediaSearchView.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// The MVVM media search screen, driven by ``MediaSearchViewModel``.
///
/// Renders the genres / search history / results / no-results surfaces, reusing the
/// store-free content subviews.
/// The view model is owned above the seam (by `SearchRootView`), so this takes a
/// plain `let viewModel`.
///
/// Focus is kept in two-way sync with the view model manually (the native
/// replacement for the former swift-navigation `.bind`): `.onChange(of:)` pushes
/// `@FocusState` changes into the model and pulls model-driven changes back.
public struct MediaSearchView: View {

    private let viewModel: MediaSearchViewModel
    @FocusState private var focusedField: MediaSearchViewModel.Field?

    public init(viewModel: MediaSearchViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .genres(let snapshot):
                // `.genre` tap was a no-op in the former reducer; kept a no-op here.
                MediaSearchGenresContentView(genres: snapshot.genres) { _ in }

            case .searchHistory(let snapshot):
                MediaSearchHistoryContentView(
                    media: snapshot.media,
                    onMovieTapped: { viewModel.selectMovie(id: $0.id) },
                    onTVSeriesTapped: { viewModel.selectTVSeries(id: $0.id) },
                    onPersonTapped: { viewModel.selectPerson(id: $0.id) }
                )

            case .searchResults(let snapshot):
                MediaSearchResultsContentView(
                    results: snapshot.results,
                    onMovieTapped: { viewModel.selectMovie(id: $0.id) },
                    onTVSeriesTapped: { viewModel.selectTVSeries(id: $0.id) },
                    onPersonTapped: { viewModel.selectPerson(id: $0.id) }
                )

            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("media-search.view")
        .overlay {
            if case .noSearchResults(let snapshot) = viewModel.viewState {
                ContentUnavailableView(
                    LocalizedStringResource("NO_RESULTS", bundle: .module),
                    systemImage: "magnifyingglass",
                    description: Text("NO_RESULTS_FOR_\(snapshot.query)_TRY_AGAIN", bundle: .module)
                )
            }
        }
        #if !os(visionOS)
        .scrollDismissesKeyboard(.interactively)
        #endif
        .searchable(
            text: Binding(
                get: { viewModel.query },
                set: { viewModel.queryChanged($0) }
            ),
            prompt: Text("MOVIES_TV_OR_PEOPLE", bundle: .module)
        )
        .searchFocused($focusedField, equals: .search)
        .onChange(of: focusedField) {
            viewModel.focusChanged(focusedField)
        }
        .onChange(of: viewModel.focusedField) {
            if focusedField != viewModel.focusedField {
                focusedField = viewModel.focusedField
            }
        }
        .task { await viewModel.fetchGenresAndSearchHistory() }
        .navigationTitle(Text("SEARCH", bundle: .module))
    }

}

#if DEBUG
    #Preview("Genres") {
        TabView {
            Tab(
                "SEARCH",
                systemImage: "magnifyingglass",
                role: .search
            ) {
                NavigationStack {
                    MediaSearchView(
                        viewModel: .preview(
                            viewState: .genres(.init(genres: Genre.mocks))
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
                        viewModel: .preview(
                            viewState: .searchHistory(.init(media: MediaPreview.mocks))
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
                        viewModel: .preview(
                            viewState: .searchResults(
                                .init(query: "running", results: MediaPreview.mocks)
                            ),
                            query: "running"
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
                        viewModel: .preview(
                            viewState: .noSearchResults(.init(query: "running")),
                            query: "running"
                        )
                    )
                }
            }
        }
    }
#endif
