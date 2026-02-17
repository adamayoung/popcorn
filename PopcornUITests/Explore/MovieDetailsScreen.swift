//
//  MovieDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class MovieDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        detailsView
    }

}

extension MovieDetailsScreen {

    private var detailsView: XCUIElement {
        app.scrollViews["movie-details.view"]
    }

}
