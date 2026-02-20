//
//  TVSeasonDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class TVSeasonDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

}

extension TVSeasonDetailsScreen {

    private var view: XCUIElement {
        app.collectionViews["tv-season-details.view"]
    }

}
