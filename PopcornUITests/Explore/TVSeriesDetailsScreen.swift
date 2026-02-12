//
//  TVSeriesDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import XCTest

@MainActor
final class TVSeriesDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        detailsView
    }

}

extension TVSeriesDetailsScreen {

    private var detailsView: XCUIElement {
        app.scrollViews["tv-series-details.view"]
    }

}
