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
        view
    }

}

extension MovieDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["movie-details.view"]
    }

}
