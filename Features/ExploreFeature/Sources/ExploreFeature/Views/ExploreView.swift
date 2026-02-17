//
//  ExploreView.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct ExploreView: View {

    @Bindable var store: StoreOf<ExploreFeature>
    private let namespace: Namespace.ID?

    public init(
        store: StoreOf<ExploreFeature>,
        transitionNamespace: Namespace.ID? = nil
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            switch store.viewState {
            case .ready(let snapshot):
                content(
                    discoverMovies: snapshot.discoverMovies,
                    trendingMovies: snapshot.trendingMovies,
                    popularMovies: snapshot.popularMovies,
                    trendingTVSeries: snapshot.trendingTVSeries,
                    trendingPeople: snapshot.trendingPeople
                )

            case .error(let error):
                ContentUnavailableView {
                    Label("UNABLE_TO_LOAD", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button("RETRY") {
                            store.send(.load)
                        }
                        .buttonStyle(.bordered)
                    }
                }

            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("explore.view")
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .navigationTitle(Text("EXPLORE", bundle: .module))
        .task { store.send(.load) }
    }

}

extension ExploreView {

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(
        discoverMovies: [MoviePreview],
        trendingMovies: [MoviePreview],
        popularMovies: [MoviePreview],
        trendingTVSeries: [TVSeriesPreview],
        trendingPeople: [PersonPreview]
    ) -> some View {
        LazyVStack {
            if !discoverMovies.isEmpty {
                discoverMoviesSection(discoverMovies)
            }
            if !trendingMovies.isEmpty {
                trendingMoviesSection(trendingMovies)
            }
            if !popularMovies.isEmpty {
                popularMoviesSection(popularMovies)
            }

            if !trendingTVSeries.isEmpty {
                trendingTVSeriesSection(trendingTVSeries)
            }

            if !trendingPeople.isEmpty {
                trendingPeopleSection(trendingPeople)
            }
        }
    }

    @ViewBuilder
    private func discoverMoviesSection(_ movies: [MoviePreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("DISCOVER_MOVIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: movies,
            type: .backdrop,
            carouselID: "discover-movies",
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                store.send(.navigate(.movieDetails(id: movie.id, transitionID: transitionID)))
            }
        )
        .accessibilityIdentifier("explore.discover-movies.carousel")
    }

    @ViewBuilder
    private func trendingMoviesSection(_ movies: [MoviePreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_MOVIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: movies,
            type: .poster,
            carouselID: "trending-movies",
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                store.send(.navigate(.movieDetails(id: movie.id, transitionID: transitionID)))
            }
        )
        .accessibilityIdentifier("explore.trending-movies.carousel")
    }

    @ViewBuilder
    private func popularMoviesSection(_ movies: [MoviePreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("POPULAR_MOVIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: movies,
            type: .backdrop,
            carouselID: "popular-movies",
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                store.send(.navigate(.movieDetails(id: movie.id, transitionID: transitionID)))
            }
        )
        .accessibilityIdentifier("explore.popular-movies.carousel")
    }

    @ViewBuilder
    private func trendingTVSeriesSection(_ tvSeries: [TVSeriesPreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_TV_SERIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        TVSeriesCarousel(
            tvSeries: tvSeries,
            type: .poster,
            carouselID: "trending-tv-series",
            transitionNamespace: namespace,
            didSelectTVSeries: { tvSeries, transitionID in
                store.send(.navigate(.tvSeriesDetails(id: tvSeries.id, transitionID: transitionID)))
            }
        )
        .accessibilityIdentifier("explore.trending-tvseries.carousel")
    }

    @ViewBuilder
    private func trendingPeopleSection(_ people: [PersonPreview]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_PEOPLE", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        PersonCarousel(
            people: people,
            carouselID: "trending-people",
            transitionNamespace: namespace,
            didSelectPerson: { person, transitionID in
                store.send(.navigate(.personDetails(id: person.id, transitionID: transitionID)))
            }
        )
        .accessibilityIdentifier("explore.trending-people.carousel")
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        ExploreView(
            store: Store(
                initialState: ExploreFeature.State(
                    viewState: .ready(
                        .init(
                            discoverMovies: MoviePreview.mocks,
                            trendingMovies: MoviePreview.mocks,
                            popularMovies: MoviePreview.mocks,
                            trendingTVSeries: TVSeriesPreview.mocks,
                            trendingPeople: PersonPreview.mocks
                        )
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
        ExploreView(
            store: Store(
                initialState: ExploreFeature.State(
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
