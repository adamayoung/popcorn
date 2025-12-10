//
//  GamesRootView.swift
//  Popcorn
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import GamesCatalogFeature
import PlotRemixGameFeature
import SwiftUI

struct GamesRootView: View {

    @Bindable var store: StoreOf<GamesRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            GamesCatalogView(
                store: store.scope(
                    state: \.gamesCatalog,
                    action: \.gamesCatalog
                ),
                transitionNamespace: namespace
            )
        } destination: { store in
            switch store.case {
            case .plotRemix(let store):
                PlotRemixGameView(
                    store: store,
                    transitionNamespace: namespace
                )
            }
        }
    }

}

#Preview {
    GamesRootView(
        store: Store(
            initialState: GamesRootFeature.State(),
            reducer: {
                GamesRootFeature()
            }
        )
    )
}
