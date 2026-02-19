//
//  SearchRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import MediaSearchFeature
import MovieDetailsFeature
import PersonDetailsFeature
import SwiftUI
import TVSeriesDetailsFeature

struct SearchRootView: View {

    @Bindable var store: StoreOf<SearchRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            MediaSearchView(
                store: store.scope(
                    state: \.mediaSearch,
                    action: \.mediaSearch
                )
            )
        } destination: { store in
            switch store.case {
            case .movieDetails(let store):
                MovieDetailsView(store: store)
            case .tvSeriesDetails(let store):
                TVSeriesDetailsView(
                    store: store,
                    transitionNamespace: namespace
                )
            case .tvSeasonDetails(let store):
                Text("Season \(store.seasonNumber)")
                    .navigationTitle("Season \(store.seasonNumber)")
            case .personDetails(let store):
                PersonDetailsView(
                    store: store,
                    transitionNamespace: namespace
                )
            }
        }
    }
}

#Preview {
    SearchRootView(
        store: Store(
            initialState: SearchRootFeature.State(),
            reducer: {
                SearchRootFeature()
            }
        )
    )
}
