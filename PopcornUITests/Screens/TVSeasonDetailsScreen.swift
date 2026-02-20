//
//  TVSeasonDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class TVSeasonDetailsScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

}

extension TVSeasonDetailsScreen {

    private var view: XCUIElement {
        app.collectionViews["tv-season-details.view"]
    }

}
