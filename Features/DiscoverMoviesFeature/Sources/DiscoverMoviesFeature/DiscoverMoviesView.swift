//
//  DiscoverMoviesView.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The discover movies view, driven by ``DiscoverMoviesViewModel``.
///
/// A standalone leaf view that owns its view model. Renders an adaptive grid of
/// movie posters — three across on iPhone, more on wider screens — with loading,
/// empty, and error states. Each poster is a zoom transition source, so pushing
/// movie details animates out of the tapped poster; `transitionNamespace` must be
/// the one the destination zooms into.
public struct DiscoverMoviesView: View {

    @State private var viewModel: DiscoverMoviesViewModel
    private let namespace: Namespace.ID

    /// Creates the discover movies view.
    ///
    /// - Parameters:
    ///   - viewModel: The view model driving the screen.
    ///   - transitionNamespace: The namespace the posters publish their zoom
    ///     transition sources into; must be the one the destination zooms into.
    public init(
        viewModel: DiscoverMoviesViewModel,
        transitionNamespace: Namespace.ID
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
        .accessibilityIdentifier("discoverMovies.view")
        .navigationTitle(Text("DISCOVER_MOVIES", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension DiscoverMoviesView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "film",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

    private var emptyBody: some View {
        ContentUnavailableView {
            Label(
                LocalizedStringResource("NO_DISCOVER_MOVIES", bundle: .module),
                systemImage: "film"
            )
        } description: {
            Text(LocalizedStringResource("NO_DISCOVER_MOVIES_DESCRIPTION", bundle: .module))
        }
    }

    private func content(movies: [MoviePreview]) -> some View {
        PosterGrid(
            items: movies,
            isLoadingMore: viewModel.isLoadingMore,
            transitionNamespace: namespace,
            accessibilityIDPrefix: "discoverMovies",
            accessibilityHint: Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module),
            posterURL: { $0.posterURL },
            transitionID: { TransitionID(movie: $0).value },
            accessibilityLabel: { $0.title },
            onSelect: { movie, transitionID in
                viewModel.selectMovie(id: movie.id, transitionID: transitionID)
            },
            loadMore: { offset in
                await viewModel.loadMoreIfNeeded(at: offset)
            }
        )
        .padding()
    }

}

#if DEBUG
    #Preview("Ready") {
        @Previewable @Namespace var namespace

        NavigationStack {
            DiscoverMoviesView(
                viewModel: .preview(movies: MoviePreview.mocks),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Empty") {
        @Previewable @Namespace var namespace

        NavigationStack {
            DiscoverMoviesView(
                viewModel: .preview(movies: []),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Loading") {
        @Previewable @Namespace var namespace

        NavigationStack {
            DiscoverMoviesView(
                viewModel: .preview(viewState: .loading),
                transitionNamespace: namespace
            )
        }
    }
#endif
