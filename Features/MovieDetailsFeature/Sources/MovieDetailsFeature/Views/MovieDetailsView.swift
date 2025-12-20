//
//  MovieDetailsView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

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
                content(
                    movie: snapshot.movie,
                    similarMovies: snapshot.similarMovies
                )

            case .error(let error):
                Text(verbatim: "\(error.localizedDescription)")

            default:
                EmptyView()
            }
        }
        .toolbar {
            if case .ready(let snapshot) = store.viewState, store.isWatchlistEnabled {
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
        }
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 1), value: store.isReady)
        .overlay {
            if store.isLoading {
                loadingBody
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
        .task {
            await store.send(.stream).finish()
        }
    }

}

extension MovieDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func content(
        movie: Movie,
        similarMovies: [MoviePreview]
    ) -> some View {
        StretchyHeaderScrollView(
            header: { header(movie: movie) },
            headerOverlay: { headerOverlay(movie: movie) },
            content: { body(movie: movie, similarMovies: similarMovies) }
        )
        .navigationTitle(movie.title)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func header(movie: Movie) -> some View {
        BackdropImage(url: movie.backdropURL)
            .flexibleHeaderContent(height: 600)
        #if os(macOS)
            .backgroundExtensionEffect()
        #endif
    }

    @ViewBuilder
    private func headerOverlay(movie: Movie) -> some View {
        LogoImage(url: movie.logoURL)
            .padding(.bottom, 20)
            .frame(maxWidth: 300, maxHeight: 150, alignment: .bottom)
    }

    @ViewBuilder
    private func body(
        movie: Movie,
        similarMovies: [MoviePreview]
    ) -> some View {
        VStack(alignment: .leading) {
            Text(verbatim: movie.overview)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            if !similarMovies.isEmpty {
                MovieCarousel(movies: similarMovies) { moviePreview in
                    store.send(.navigate(.movieDetails(id: moviePreview.id)))
                }
            }
        }
        .padding(.bottom)
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
                            similarMovies: MoviePreview.mocks
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
