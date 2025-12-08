//
//  MoviesRootView.swift
//  Popcorn
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import MovieDetailsFeature
import SwiftUI
import TrendingMoviesFeature

struct MoviesRootView: View {

    @Bindable var store: StoreOf<MoviesRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TrendingMoviesView(
                store: store.scope(
                    state: \.trending,
                    action: \.trending
                ),
                transitionNamespace: namespace
            )
        } destination: { store in
            switch store.case {
            case .details(let store):
                MovieDetailsView(
                    store: store,
                    transitionNamespace: namespace
                )
            }
        }
    }
}

#Preview {
    MoviesRootView(
        store: Store(
            initialState: MoviesRootFeature.State(),
            reducer: {
                MoviesRootFeature()
            }
        )
    )
}
