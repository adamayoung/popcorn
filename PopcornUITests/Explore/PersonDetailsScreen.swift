//
//  PersonDetailsScreen.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
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
