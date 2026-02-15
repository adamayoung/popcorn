//
//  GamesRootView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
        #if !os(macOS)
        .fullScreenCover(
            store: store.scope(
                state: \.$plotRemixGame,
                action: \.plotRemixGame
            )
        ) { store in
            PlotRemixGameView(store: store, transitionNamespace: namespace)
        }
        #else
        .sheet(
                    store: store.scope(
                        state: \.$plotRemixGame,
                        action: \.plotRemixGame
                    )
                ) { store in
                    PlotRemixGameView(store: store, transitionNamespace: namespace)
                }
        #endif
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
