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
        NavigationStack {
            GamesCatalogView(
                store: store.scope(
                    state: \.gamesCatalog,
                    action: \.gamesCatalog
                ),
                transitionNamespace: namespace
            )
        }
        .fullScreenCover(
            store: store.scope(
                state: \.$plotRemixGame,
                action: \.plotRemixGame
            )
        ) { store in
            PlotRemixGameView(store: store, transitionNamespace: namespace)
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
