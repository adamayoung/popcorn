//
//  PersonDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import XCTest

@MainActor
final class PersonDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        detailsView
    }

}

extension PersonDetailsScreen {

    private var detailsView: XCUIElement { app.scrollViews["person-details.view"] }

}
