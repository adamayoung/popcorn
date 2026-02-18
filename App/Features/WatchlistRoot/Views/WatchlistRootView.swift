//
//  WatchlistRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import MovieDetailsFeature
import PersonDetailsFeature
import SwiftUI
import WatchlistFeature

struct WatchlistRootView: View {

    @Bindable var store: StoreOf<WatchlistRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            WatchlistView(
                store: store.scope(
                    state: \.watchlist,
                    action: \.watchlist
                ),
                transitionNamespace: namespace
            )
        } destination: { store in
            switch store.case {
            case .movieDetails(let store):
                movieDetails(store: store)
            case .personDetails(let store):
                PersonDetailsView(
                    store: store,
                    transitionNamespace: namespace
                )
            }
        }
    }

    @ViewBuilder
    private func movieDetails(store: StoreOf<MovieDetailsFeature>) -> some View {
        if let transitionID = store.transitionID {
            MovieDetailsView(store: store)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            MovieDetailsView(store: store)
        }
    }

}

#Preview {
    WatchlistRootView(
        store: Store(
            initialState: WatchlistRootFeature.State(),
            reducer: {
                WatchlistRootFeature()
            }
        )
    )
}
