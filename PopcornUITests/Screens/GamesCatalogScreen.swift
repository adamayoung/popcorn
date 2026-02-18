//
//  GamesCatalogScreen.swift
//  Popcorn
//
//  Created by Adam Young on 18/02/2026.
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
