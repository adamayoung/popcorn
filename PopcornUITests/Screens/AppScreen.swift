//
//  AppScreen.swift
//  Popcorn
//
//  Created by Adam Young on 18/02/2026.
//

import XCTest

@MainActor
final class AppScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

    @discardableResult
    func tapExploreTab() -> ExploreScreen {
        exploreTab.tap()
        return ExploreScreen(app: app)
    }

    @discardableResult
    func tapWatchlistTab() -> WatchlistScreen {
        watchlistTab.tap()
        return WatchlistScreen(app: app)
    }

    @discardableResult
    func tapGamesTab() -> GamesCatalogScreen {
        gamesTab.tap()
        return GamesCatalogScreen(app: app)
    }

    @discardableResult
    func tapSearchTab() -> MediaSearchScreen {
        searchTab.tap()
        return MediaSearchScreen(app: app)
    }

}

extension AppScreen {

    private var view: XCUIElement {
        app.tabBars["Tab Bar"]
    }

    private var exploreTab: XCUIElement {
        app.buttons["app.tabview.explore"]
    }

    private var watchlistTab: XCUIElement {
        app.buttons["app.tabview.watchlist"]
    }

    private var gamesTab: XCUIElement {
        app.buttons["app.tabview.games"]
    }

    private var searchTab: XCUIElement {
        app.buttons["app.tabview.search"]
    }

}
