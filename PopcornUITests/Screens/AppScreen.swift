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

    func tapExploreTab() {
        exploreTab.tap()
    }

    func tapWatchlistTab() {
        watchlistTab.tap()
    }

    func tapGamesTab() {
        gamesTab.tap()
    }

    func tapSearchTab() {
        searchTab.tap()
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
