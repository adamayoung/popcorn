//
//  TVSeriesDetailsScreen.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
//

import XCTest

@MainActor
final class TVSeriesDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        detailsView
    }

}

extension TVSeriesDetailsScreen {

    private var detailsView: XCUIElement { app.scrollViews["tv-series-details.view"] }

}
