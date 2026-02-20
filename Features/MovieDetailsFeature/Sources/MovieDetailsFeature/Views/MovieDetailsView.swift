//
//  MovieDetailsView.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct MovieDetailsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable private var store: StoreOf<MovieDetailsFeature>

    public init(store: StoreOf<MovieDetailsFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
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
            if case .ready(let snapshot) = store.viewState {
                if store.isWatchlistEnabled {
                    ToolbarItem(placement: toolbarTrailingPlacement) {
                        Button(
                            snapshot.movie.isOnWatchlist ?
                                LocalizedStringResource("REMOVE_FROM_WATCHLIST", bundle: .module) :
                                LocalizedStringResource("ADD_TO_WATCHLIST", bundle: .module),
                            systemImage: snapshot.movie.isOnWatchlist ? "eye" : "plus"
                        ) {
                            store.send(.toggleOnWatchlist)
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

                if store.isIntelligenceEnabled {
                    ToolbarItem(placement: toolbarTrailingPlacement) {
                        Button(
                            LocalizedStringResource("MOVIE_INTELLIGENCE", bundle: .module),
                            systemImage: "apple.intelligence"
                        ) {
                            store.send(.navigate(.movieIntelligence(id: snapshot.movie.id)))
                        }
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: store.viewState.isReady)
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
        .task {
            store.send(.fetch)
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

    private func content(_ snapshot: MovieDetailsFeature.ViewSnapshot) -> some View {
        MovieDetailsContentView(
            movie: snapshot.movie,
            recommendedMovies: snapshot.recommendedMovies,
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
            isBackdropFocalPointEnabled: store.isBackdropFocalPointEnabled,
            didSelectPerson: { personID in
                store.send(.navigate(.personDetails(id: personID)))
            },
            didSelectMovie: { movieID in
                store.send(.navigate(.movieDetails(id: movieID)))
            },
            navigateToCastAndCrew: { movieID in
                store.send(.navigate(.castAndCrew(movieID: movieID)))
            }
        )
    }

}

extension MovieDetailsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentUnavailableView {
            Label(LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module), systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.message)
        } actions: {
            if error.isRetryable {
                Button {
                    store.send(.fetch)
                } label: {
                    Text("RETRY", bundle: .module)
                }
                .buttonStyle(.bordered)
            }
        }
    }

}

#Preview("Ready") {
    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetailsFeature.State(
                    movieID: Movie.mock.id,
                    viewState: .ready(
                        .init(
                            movie: Movie.mock,
                            recommendedMovies: MoviePreview.mocks,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
                    )
                ),
                reducer: {
                    EmptyReducer()
                }
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetailsFeature.State(
                    movieID: Movie.mock.id,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetailsFeature.State(
                    movieID: Movie.mock.id,
                    viewState: .error(ViewStateError(message: "Error loading movie"))
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
