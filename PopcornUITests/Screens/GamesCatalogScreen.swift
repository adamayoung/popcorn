//
//  GamesCatalogScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class GamesCatalogScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

}

extension GamesCatalogScreen {

    private var view: XCUIElement {
        app.scrollViews["games-catalog.view"]
    }

}
