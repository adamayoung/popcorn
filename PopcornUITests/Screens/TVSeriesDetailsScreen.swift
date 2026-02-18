//
//  TVSeriesDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class TVSeriesDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

}

extension TVSeriesDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["tv-series-details.view"]
    }

}
