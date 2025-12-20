//
//  TrendingMoviesView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct TrendingMoviesView: View {

    @Bindable var store: StoreOf<TrendingMoviesFeature>
    private let namespace: Namespace.ID

    private var movies: [MoviePreview] {
        store.movies
    }

    private var isLoading: Bool {
        store.isInitiallyLoading
    }

    public init(
        store: StoreOf<TrendingMoviesFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        List(movies) { movie in
            NavigationRow {
                store.send(.navigate(.movieDetails(id: movie.id)))
            } content: {
                MovieRow(
                    id: movie.id,
                    title: movie.title,
                    posterURL: movie.posterURL
                )
            }
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Trending")
        .task {
            store.send(.loadTrendingMovies)
        }
    }

}

#Preview {
    @Previewable @Namespace var namespace

    TrendingMoviesView(
        store: Store(
            initialState: TrendingMoviesFeature.State(),
            reducer: {
                TrendingMoviesFeature()
            }
        ),
        transitionNamespace: namespace
    )
}
