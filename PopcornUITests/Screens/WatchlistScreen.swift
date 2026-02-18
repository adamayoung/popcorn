//
//  WatchlistScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class WatchlistScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

}

extension WatchlistScreen {

    private var view: XCUIElement {
        app.scrollViews["watchlist.view"]
    }

}
