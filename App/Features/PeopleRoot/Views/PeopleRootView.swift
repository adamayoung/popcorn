//
//  PeopleRootView.swift
//  Popcorn
//
//  Created by Adam Young on 19/11/2025.
//

import ComposableArchitecture
import PersonDetailsFeature
import SwiftUI
import TrendingPeopleFeature

struct PeopleRootView: View {

    @Bindable var store: StoreOf<PeopleRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            TrendingPeopleView(
                store: store.scope(
                    state: \.trending,
                    action: \.trending
                )
            )
        } destination: { store in
            switch store.case {
            case .details(let store):
                PersonDetailsView(
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
