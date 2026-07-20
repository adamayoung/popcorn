//
//  TrendingMoviesView.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The trending movies view, driven by ``TrendingMoviesViewModel``.
///
/// A standalone leaf view that owns its view model. Renders an adaptive grid of
/// movie posters — three across on iPhone, more on wider screens — with loading,
/// empty, and error states. Each poster is a zoom transition source, so pushing
/// movie details animates out of the tapped poster; `transitionNamespace` must be
/// the one the destination zooms into.
public struct TrendingMoviesView: View {

    /// A 100pt minimum keeps three posters across on every iPhone width
    /// (375–440pt) while letting iPad and Mac fit more.
    private static let columns = [
        GridItem(.adaptive(minimum: 100), spacing: .spacing16)
    ]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: TrendingMoviesViewModel
    private let namespace: Namespace.ID

    public init(
        viewModel: TrendingMoviesViewModel,
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
        .accessibilityIdentifier("trendingMovies.view")
        .navigationTitle(Text("TRENDING_MOVIES", bundle: .module))
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension TrendingMoviesView {

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
                LocalizedStringResource("NO_TRENDING_MOVIES", bundle: .module),
                systemImage: "film"
            )
        } description: {
            Text(LocalizedStringResource("NO_TRENDING_MOVIES_DESCRIPTION", bundle: .module))
        }
    }

    private func content(movies: [MoviePreview]) -> some View {
        LazyVGrid(columns: Self.columns, spacing: .spacing16) {
            ForEach(movies.enumerated(), id: \.element.id) { offset, movie in
                let transitionID = TransitionID(movie: movie).value

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
                .accessibilityIdentifier("trendingMovies.movie.\(offset)")
                .accessibilityLabel(Text(verbatim: movie.title))
                .accessibilityHint(Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module))
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
            TrendingMoviesView(
                viewModel: .preview(movies: MoviePreview.mocks),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Empty") {
        @Previewable @Namespace var namespace

        NavigationStack {
            TrendingMoviesView(
                viewModel: .preview(movies: []),
                transitionNamespace: namespace
            )
        }
    }

    #Preview("Loading") {
        @Previewable @Namespace var namespace

        NavigationStack {
            TrendingMoviesView(
                viewModel: .preview(viewState: .loading),
                transitionNamespace: namespace
            )
        }
    }
#endif
