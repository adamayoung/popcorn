//
//  GamesCatalogScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class GamesCatalogScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

}

extension GamesCatalogScreen {

    private var view: XCUIElement {
        app.scrollViews["games-catalog.view"]
    }

}
