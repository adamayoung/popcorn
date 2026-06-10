//
//  WatchlistView.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The watchlist screen, driven by ``WatchlistViewModel``.
///
/// Renders a grid of watchlist movie posters with loading, empty, and error
/// states. The view owns its view model via `@State`, so it is self-contained
/// and behaves correctly regardless of how a host retains it. The transition
/// namespace is optional — supply one to enable the zoom transition into movie
/// details; omit it (e.g. in isolation or previews) to render without it.
public struct WatchlistView: View {

    private static let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: WatchlistViewModel
    private let namespace: Namespace.ID?

    public init(
        viewModel: WatchlistViewModel,
        transitionNamespace: Namespace.ID? = nil
    ) {
        _viewModel = State(initialValue: viewModel)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .ready(let snapshot):
                if snapshot.movies.isEmpty {
                    emptyBody
                        .containerRelativeFrame(.vertical)
                } else {
                    content(movies: snapshot.movies)
                }
            case .error(let error):
                errorBody(error)
                    .containerRelativeFrame(.vertical)
            default:
                EmptyView()
            }
        }
        .overlay {
            if viewModel.viewState.isLoading {
                ProgressView()
                    .accessibilityLabel(Text("LOADING", bundle: .module))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .accessibilityIdentifier("watchlist.view")
        .navigationTitle(Text("WATCHLIST", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

private extension View {

    /// Applies `matchedTransitionSource(id:in:)` only when a namespace is
    /// supplied, so the view renders unchanged when hosted without one.
    @ViewBuilder
    func matchedTransitionSource(
        id: some Hashable & Sendable,
        in namespace: Namespace.ID?
    ) -> some View {
        if let namespace {
            matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }

}

extension WatchlistView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "eye",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

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
            ForEach(Array(movies.enumerated()), id: \.element.id) { offset, movie in
                let transitionID = "\(movie.id)"
                Button {
                    viewModel.selectMovie(id: movie.id, transitionID: transitionID)
                } label: {
                    PosterImage(url: movie.posterURL)
                        .aspectRatio(500.0 / 750.0, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        }
                }
                .accessibilityIdentifier("watchlist.movie.\(offset)")
                .accessibilityLabel(movie.title)
                .buttonStyle(.plain)
                .matchedTransitionSource(id: transitionID, in: namespace)
            }
        }
        .animation(reduceMotion ? nil : .default, value: movies)
        .padding()
    }

}

#if DEBUG
    #Preview("Ready") {
        @Previewable @Namespace var namespace

        NavigationStack {
            WatchlistView(
                viewModel: .preview(viewState: .ready(.init(movies: MoviePreview.mocks))),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Loading") {
        @Previewable @Namespace var namespace

        NavigationStack {
            WatchlistView(
                viewModel: .preview(viewState: .loading),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Empty") {
        @Previewable @Namespace var namespace

        NavigationStack {
            WatchlistView(
                viewModel: .preview(viewState: .ready(.init(movies: []))),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Error") {
        @Previewable @Namespace var namespace

        NavigationStack {
            WatchlistView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchWatchlistError.unknown()))),
                transitionNamespace: namespace
            )
        }
    }
#endif
