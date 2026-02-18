//
//  AppScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class AppScreen: Screen {

    override var uniqueElement: XCUIElement {
        app
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

    private var exploreTab: XCUIElement {
        app.buttons["app.tabview.explore"].firstMatch
    }

    private var watchlistTab: XCUIElement {
        app.buttons["app.tabview.watchlist"].firstMatch
    }

    private var gamesTab: XCUIElement {
        app.buttons["app.tabview.games"].firstMatch
    }

    private var searchTab: XCUIElement {
        app.buttons["app.tabview.search"].firstMatch
    }

}
