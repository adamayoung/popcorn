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

    init(
        router: GamesRouter,
        factory: ViewModelFactory,
        namespace: Namespace.ID
    ) {
        _router = Bindable(wrappedValue: router)
        self.factory = factory
        self.namespace = namespace
    }

    var body: some View {
        NavigationStack {
            GamesCatalogScreen(
                viewModel: factory.makeGamesCatalog(
                    navigator: GamesRouterNavigator(router: router)
                ),
                transitionNamespace: namespace
            )
        }
        #if !os(macOS)
        .fullScreenCover(item: $router.presentedGame) { presented in
            PlotRemixGameScreen(
                viewModel: factory.makePlotRemixGame(
                    gameID: presented.gameID,
                    navigator: GamesRouterNavigator(router: router)
                ),
                transitionNamespace: namespace
            )
        }
        #else
        .sheet(item: $router.presentedGame) { presented in
                    PlotRemixGameScreen(
                        viewModel: factory.makePlotRemixGame(
                            gameID: presented.gameID,
                            navigator: GamesRouterNavigator(router: router)
                        ),
                        transitionNamespace: namespace
                    )
                }
        #endif
    }

}
