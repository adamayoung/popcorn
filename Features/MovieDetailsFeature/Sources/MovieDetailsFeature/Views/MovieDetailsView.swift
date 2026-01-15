//
//  MovieDetailsView.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct MovieDetailsView: View {

    @Bindable private var store: StoreOf<MovieDetailsFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<MovieDetailsFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
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
                    ToolbarItem(placement: .primaryAction) {
                        Button(
                            snapshot.movie.isOnWatchlist ? "REMOVE_FROM_WATCHLIST" : "ADD_TO_WATCHLIST",
                            systemImage: snapshot.movie.isOnWatchlist ? "eye.square.fill" : "eye.square"
                        ) {
                            store.send(.toggleOnWatchlist)
                        }
                        .sensoryFeedback(.selection, trigger: snapshot.movie.isOnWatchlist)
                    }
                }

                if store.isIntelligenceEnabled {
                    ToolbarItem(placement: .primaryAction) {
                        Button(
                            "MOVIE_INTELLIGENCE",
                            systemImage: "apple.intelligence"
                        ) {
                            store.send(.navigate(.movieIntelligence(id: snapshot.movie.id)))
                        }
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 1), value: store.viewState.isReady)
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

    private var loadingBody: some View {
        ProgressView()
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
    @Previewable @Namespace var namespace

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
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Loading") {
    @Previewable @Namespace var namespace

    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetailsFeature.State(
                    movieID: Movie.mock.id,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Error") {
    @Previewable @Namespace var namespace

    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetailsFeature.State(
                    movieID: Movie.mock.id,
                    viewState: .error(ViewStateError(message: "Error loading movie"))
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
