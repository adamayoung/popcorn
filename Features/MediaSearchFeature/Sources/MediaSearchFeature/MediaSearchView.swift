//
//  MediaSearchView.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The media search screen, driven by ``MediaSearchViewModel``.
///
/// Renders the genres / search history / results / no-results surfaces, reusing
/// the content subviews. The view owns its view model via `@State`, so it is
/// self-contained and behaves correctly regardless of how a host retains it.
///
/// Focus is kept in two-way sync with the view model: `.onChange(of:)` pushes
/// `@FocusState` changes into the model and pulls model-driven changes back.
public struct MediaSearchView: View {

    @State private var viewModel: MediaSearchViewModel
    @FocusState private var focusedField: MediaSearchViewModel.Field?

    public init(viewModel: MediaSearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .genres(let snapshot):
                // Genre selection is intentionally a no-op.
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

            case .error(let error):
                errorBody(error)

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

extension MediaSearchView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "magnifyingglass",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.retry() }
        )
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

    #Preview("Error") {
        TabView {
            Tab(
                "SEARCH",
                systemImage: "magnifyingglass",
                role: .search
            ) {
                NavigationStack {
                    MediaSearchView(
                        viewModel: .preview(
                            viewState: .error(ViewStateError(message: "Something went wrong"))
                        )
                    )
                }
            }
        }
    }
#endif
