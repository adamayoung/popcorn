//
//  PersonDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class PersonDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

}

extension PersonDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["person-details.view"]
    }

}
