//
//  WatchlistView.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct WatchlistView: View {

    private static let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable var store: StoreOf<WatchlistFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<WatchlistFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            switch store.viewState {
            case .ready(let snapshot):
                if snapshot.movies.isEmpty {
                    emptyBody
                        .containerRelativeFrame(.vertical)
                } else {
                    content(movies: snapshot.movies)
                }
            case .error(let error):
                ContentUnavailableView {
                    Label(
                        LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module),
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button(LocalizedStringResource("RETRY", bundle: .module)) {
                            store.send(.fetch)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .containerRelativeFrame(.vertical)
            default:
                EmptyView()
            }
        }
        .overlay {
            if store.viewState.isLoading {
                ProgressView()
                    .accessibilityLabel(Text("LOADING", bundle: .module))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .accessibilityIdentifier("watchlist.view")
        .navigationTitle(Text("WATCHLIST", bundle: .module))
        .task { store.send(.fetch) }
    }

}

extension WatchlistView {

    private var emptyBody: some View {
        ContentUnavailableView {
            Label(
                LocalizedStringResource("NO_WATCHLIST_MOVIES", bundle: .module),
                systemImage: "eye"
            )
        } description: {
            Text(LocalizedStringResource("NO_WATCHLIST_MOVIES_DESCRIPTION", bundle: .module))
        }
    }

    private func content(movies: [MoviePreview]) -> some View {
        LazyVGrid(columns: Self.columns, spacing: 16) {
            ForEach(movies) { movie in
                let transitionID = "\(movie.id)"
                Button {
                    store.send(
                        .navigate(.movieDetails(id: movie.id, transitionID: transitionID))
                    )
                } label: {
                    PosterImage(url: movie.posterURL)
                        .aspectRatio(500.0 / 750.0, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        }
                        .accessibilityLabel(movie.title)
                }
                .buttonStyle(.plain)
                .matchedTransitionSource(id: transitionID, in: namespace)
            }
        }
        .animation(reduceMotion ? nil : .default, value: movies)
        .padding()
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        WatchlistView(
            store: Store(
                initialState: WatchlistFeature.State(
                    viewState: .ready(
                        .init(movies: MoviePreview.mocks)
                    )
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Loading") {
    @Previewable @Namespace var namespace

    NavigationStack {
        WatchlistView(
            store: Store(
                initialState: WatchlistFeature.State(
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Empty") {
    @Previewable @Namespace var namespace

    NavigationStack {
        WatchlistView(
            store: Store(
                initialState: WatchlistFeature.State(
                    viewState: .ready(.init(movies: []))
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
