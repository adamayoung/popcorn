//
//  MovieDetailsScreen.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
//

import XCTest

@MainActor
final class MovieDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        detailsView
    }

}

extension MovieDetailsScreen {

    private var detailsView: XCUIElement { app.scrollViews["movie-details.view"] }

}
