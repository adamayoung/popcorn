//
//  ExploreView.swift
//  ExploreFeature
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ExploreView: View {

    @Bindable var store: StoreOf<ExploreFeature>
    private let namespace: Namespace.ID

    private var discoverMovies: [MoviePreview] { store.discoverMovies.items }
    private var trendingMovies: [MoviePreview] { store.trendingMovies.items }
    private var popularMovies: [MoviePreview] { store.popularMovies.items }
    private var trendingTVSeries: [TVSeriesPreview] { store.trendingTVSeries.items }
    private var trendingPeople: [PersonPreview] { store.trendingPeople.items }
    private var isReady: Bool { store.isReady }

    public init(
        store: StoreOf<ExploreFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ZStack {
            if isReady {
                ScrollView {
                    loadedBody
                }
            }
        }
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 1), value: isReady)
        .overlay {
            if !isReady {
                loadingBody
            }
        }
        .navigationTitle(Text("HOME", bundle: .module))
        .task { store.send(.load) }
    }

}

extension ExploreView {

    @ViewBuilder
    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var loadedBody: some View {
        LazyVStack {
            discoverMoviesSection
            trendingMoviesSection
            popularMoviesSection

            trendingTVSeriesSection

            trendingPeopleSection
        }
    }

    @ViewBuilder private var discoverMoviesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("DISCOVER_MOVIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: discoverMovies,
            type: .backdrop,
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                store.send(.navigate(.movieDetails(id: movie.id, transitionID: transitionID)))
            }
        )
    }

    @ViewBuilder private var trendingMoviesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_MOVIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: trendingMovies,
            type: .poster,
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                store.send(.navigate(.movieDetails(id: movie.id, transitionID: transitionID)))
            }
        )
    }

    @ViewBuilder private var popularMoviesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("POPULAR_MOVIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        MovieCarousel(
            movies: popularMovies,
            type: .backdrop,
            transitionNamespace: namespace,
            didSelectMovie: { movie, transitionID in
                store.send(.navigate(.movieDetails(id: movie.id, transitionID: transitionID)))
            }
        )
    }

    @ViewBuilder private var trendingTVSeriesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_TV_SERIES", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        TVSeriesCarousel(
            tvSeries: trendingTVSeries,
            type: .poster,
            transitionNamespace: namespace,
            didSelectTVSeries: { tvSeries, transitionID in
                store.send(.navigate(.tvSeriesDetails(id: tvSeries.id, transitionID: transitionID)))
            }
        )
    }

    @ViewBuilder private var trendingPeopleSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TRENDING_PEOPLE", bundle: .module)
                .font(.title2)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, alignment: .leading)

        PersonCarousel(
            people: trendingPeople,
            transitionNamespace: namespace,
            didSelectPerson: { person, transitionID in
                store.send(.navigate(.personDetails(id: person.id, transitionID: transitionID)))
            }
        )
    }

}

#Preview {
    @Previewable @Namespace var namespace

    NavigationStack {
        ExploreView(
            store: Store(
                initialState: ExploreFeature.State(),
                reducer: {
                    ExploreFeature()
                }
            ),
            transitionNamespace: namespace
        )
    }
}
