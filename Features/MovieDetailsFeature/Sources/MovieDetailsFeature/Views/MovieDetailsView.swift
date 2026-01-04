//
//  MovieDetailsView.swift
//  MovieDetailsFeature
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
                    recommendedMovies: snapshot.recommendedMovies,
                    castMembers: snapshot.castMembers,
                    crewMembers: snapshot.crewMembers
                )

            case .error(let error):
                Text(verbatim: "\(error.localizedDescription)")

            default:
                EmptyView()
            }
        }
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
            store.send(.fetch)
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
        recommendedMovies: [MoviePreview],
        castMembers: [CastMember],
        crewMembers: [CrewMember]
    ) -> some View {
        StretchyHeaderScrollView(
            header: { header(movie: movie) },
            headerOverlay: { headerOverlay(movie: movie) },
            content: {
                body(
                    movie: movie,
                    recommendedMovies: recommendedMovies,
                    castMembers: castMembers,
                    crewMembers: crewMembers
                )
            }
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
        recommendedMovies: [MoviePreview],
        castMembers: [CastMember],
        crewMembers: [CrewMember]
    ) -> some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Section {
                Text(verbatim: movie.overview)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)

            Section(header: castAndCrewHeader) {
                CastAndCrewCarousel(
                    castMembers: castMembers,
                    crewMembers: crewMembers,
                    didSelectPerson: { personID in
                        store.send(.navigate(.personDetails(id: personID)))
                    }
                )
            }
            .padding(.bottom)

            if !recommendedMovies.isEmpty {
                Section(header: recommendedHeader) {
                    MovieCarousel(movies: recommendedMovies) { moviePreview in
                        store.send(.navigate(.movieDetails(id: moviePreview.id)))
                    }
                }
            }
        }
        .padding(.vertical)
    }

    private var castAndCrewHeader: some View {
        Button {} label: {
            HStack {
                Text("CAST_AND_CREW", bundle: .module)
                    .font(.title)
                Image(systemName: "greaterthan")
                    .foregroundStyle(.secondary)
            }
            .fontWeight(.heavy)
            .padding(.leading)
        }
        .buttonStyle(.plain)
    }

    private var recommendedHeader: some View {
        Button {} label: {
            HStack {
                Text("RECOMMENDED", bundle: .module)
                    .font(.title)
                Image(systemName: "greaterthan")
                    .foregroundStyle(.secondary)
            }
            .fontWeight(.heavy)
            .padding(.leading)
        }
        .buttonStyle(.plain)
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
