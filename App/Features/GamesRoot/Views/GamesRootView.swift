//
//  GamesRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import GamesCatalogFeature
import PlotRemixGameFeature
import SwiftUI

/// The MVVM Games tab root. Hosts the catalog in a `NavigationStack` and presents
/// the Plot Remix game modally, driven by ``GamesRouter``. The MVVM replacement
/// for the store-based `GamesRootView` + `GamesRootFeature`.
struct GamesRootView: View {

    @Bindable private var router: GamesRouter
    private let factory: ViewModelFactory
    private let namespace: Namespace.ID

    /// The catalog home view model, owned here (above the screen seam) so it
    /// survives the router-driven body re-renders that presenting the game causes —
    /// matching the other tab roots (it was previously rebuilt inline in `body`).
    @State private var gamesCatalogViewModel: GamesCatalogViewModel

    init(
        router: GamesRouter,
        factory: ViewModelFactory,
        namespace: Namespace.ID
    ) {
        _router = Bindable(wrappedValue: router)
        self.factory = factory
        self.namespace = namespace
        _gamesCatalogViewModel = State(
            initialValue: factory.makeGamesCatalog(
                navigator: GamesRouterNavigator(router: router)
            )
        )
    }

    var body: some View {
        NavigationStack {
            GamesCatalogView(
                viewModel: gamesCatalogViewModel,
                transitionNamespace: namespace
            )
        }
        .platformModal(item: $router.presentedGame) { presented in
            PlotRemixGameView(
                viewModel: factory.makePlotRemixGame(
                    gameID: presented.gameID,
                    navigator: GamesRouterNavigator(router: router)
                ),
                transitionNamespace: namespace
            )
        }
    }

}
