//
//  MovieDetailsView.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The movie details screen, driven by ``MovieDetailsViewModel``.
///
/// Renders ``MovieDetailsContentView`` along with toolbar, loading, and error chrome.
public struct MovieDetailsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: MovieDetailsViewModel

    public init(viewModel: MovieDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let movie):
                content(movie)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("movie-details.view")
        .toolbar {
            if case .ready(let movie) = viewModel.viewState {
                if viewModel.isWatchlistEnabled {
                    ToolbarItem(placement: toolbarTrailingPlacement) {
                        Button(
                            movie.isOnWatchlist ?
                                LocalizedStringResource("REMOVE_FROM_WATCHLIST", bundle: .module) :
                                LocalizedStringResource("ADD_TO_WATCHLIST", bundle: .module),
                            systemImage: movie.isOnWatchlist ? "eye" : "plus"
                        ) {
                            Task { await viewModel.toggleOnWatchlist() }
                        }
                        .accessibilityIdentifier(
                            movie.isOnWatchlist
                                ? "movie-details.watchlist-toggle.on"
                                : "movie-details.watchlist-toggle.off"
                        )
                        .contentTransition(.symbolEffect(.replace))
                        .animation(reduceMotion ? nil : .default, value: movie.isOnWatchlist)
                        .sensoryFeedback(.selection, trigger: movie.isOnWatchlist)
                    }
                }

                if viewModel.isIntelligenceEnabled {
                    ToolbarItem(placement: toolbarTrailingPlacement) {
                        Button(
                            LocalizedStringResource("MOVIE_INTELLIGENCE", bundle: .module),
                            systemImage: "apple.intelligence"
                        ) {
                            viewModel.openIntelligence()
                        }
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: viewModel.viewState.isReady)
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            viewModel.didAppear()
        }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension MovieDetailsView {

    private var toolbarTrailingPlacement: ToolbarItemPlacement {
        #if os(macOS)
            .automatic
        #else
            .primaryAction
        #endif
    }

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension MovieDetailsView {

    private func content(_ movie: Movie) -> some View {
        MovieDetailsContentView(
            movie: movie,
            recommendedMoviesState: viewModel.recommendedMoviesState,
            castAndCrewState: viewModel.castAndCrewState,
            isBackdropFocalPointEnabled: viewModel.isBackdropFocalPointEnabled,
            didSelectPerson: { personID in
                viewModel.selectPerson(id: personID)
            },
            didSelectMovie: { movieID in
                viewModel.selectMovie(id: movieID)
            },
            navigateToCastAndCrew: { _ in
                viewModel.openCastAndCrew()
            }
        )
    }

}

extension MovieDetailsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "film",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            MovieDetailsView(
                viewModel: .preview(
                    viewState: .ready(.mock),
                    recommendedMoviesState: .ready(MoviePreview.mocks),
                    castAndCrewState: .ready(.mock)
                )
            )
        }
    }

    #Preview("Sections Loading") {
        NavigationStack {
            MovieDetailsView(
                viewModel: .preview(
                    viewState: .ready(.mock),
                    recommendedMoviesState: .loading,
                    castAndCrewState: .loading
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            MovieDetailsView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            MovieDetailsView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchMovieError.notFound())))
            )
        }
    }
#endif
