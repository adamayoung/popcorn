//
//  GamesRouter.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import GamesCatalogFeature
import Observation
import PlotRemixGameFeature

/// Owns the Games tab's modal navigation state. The MVVM replacement for
/// `GamesRootFeature`'s `@Presents var plotRemixGame`.
///
/// The Games tab has no push stack — only a single modal presentation (the Plot
/// Remix game), so the router holds just the presented-game item.
@Observable
@MainActor
final class GamesRouter {

    /// The currently presented game, or `nil` when no modal is shown. Bound to the
    /// games root's `.fullScreenCover(item:)` / `.sheet(item:)`.
    var presentedGame: PresentedGame?

    init(presentedGame: PresentedGame? = nil) {
        self.presentedGame = presentedGame
    }

    /// Identifies a presented game by its id, for `item`-based modal presentation.
    struct PresentedGame: Identifiable, Hashable {
        let gameID: Int
        var id: Int { gameID }
    }

}

/// Translates leaf-feature navigation requests into ``GamesRouter`` mutations.
///
/// Implements both games leaves' navigating protocols: ``GamesCatalogNavigating``
/// maps a game selection to a modal presentation, and ``PlotRemixGameNavigating``
/// dismisses it. Mirrors `GamesRootFeature`'s reducer mapping (`id == 1` →
/// present, other ids no-op).
@MainActor
struct GamesRouterNavigator: GamesCatalogNavigating, PlotRemixGameNavigating {

    let router: GamesRouter

    func openGame(id: Int) {
        if id == 1 {
            router.presentedGame = .init(gameID: 1)
        }
    }

    func dismiss() {
        router.presentedGame = nil
    }

}
