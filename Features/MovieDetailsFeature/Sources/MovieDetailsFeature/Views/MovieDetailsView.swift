//
//  MovieDetailsView.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM movie details screen, driven by ``MovieDetailsViewModel``.
///
/// Renders the same store-free ``MovieDetailsContentView`` and reproduces the
/// exact toolbar / loading / error chrome of the former TCA `MovieDetailsView`,
/// so recorded snapshots stay byte-identical.
public struct MovieDetailsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: MovieDetailsViewModel

    public init(viewModel: MovieDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(snapshot)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("movie-details.view")
        .toolbar {
            if case .ready(let snapshot) = viewModel.viewState {
                if viewModel.isWatchlistEnabled {
                    ToolbarItem(placement: toolbarTrailingPlacement) {
                        Button(
                            snapshot.movie.isOnWatchlist ?
                                LocalizedStringResource("REMOVE_FROM_WATCHLIST", bundle: .module) :
                                LocalizedStringResource("ADD_TO_WATCHLIST", bundle: .module),
                            systemImage: snapshot.movie.isOnWatchlist ? "eye" : "plus"
                        ) {
                            Task { await viewModel.toggleOnWatchlist() }
                        }
                        .accessibilityIdentifier(
                            snapshot.movie.isOnWatchlist
                                ? "movie-details.watchlist-toggle.on"
                                : "movie-details.watchlist-toggle.off"
                        )
                        .contentTransition(.symbolEffect(.replace))
                        .animation(reduceMotion ? nil : .default, value: snapshot.movie.isOnWatchlist)
                        .sensoryFeedback(.selection, trigger: snapshot.movie.isOnWatchlist)
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

    private func content(_ snapshot: MovieDetailsViewSnapshot) -> some View {
        MovieDetailsContentView(
            movie: snapshot.movie,
            recommendedMovies: snapshot.recommendedMovies,
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
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
                    viewState: .ready(
                        .init(
                            movie: Movie.mock,
                            recommendedMovies: MoviePreview.mocks,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
                    )
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
