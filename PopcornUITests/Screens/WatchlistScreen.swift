//
//  WatchlistScreen.swift
//  Popcorn
//
//  Created by Adam Young on 18/02/2026.
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
