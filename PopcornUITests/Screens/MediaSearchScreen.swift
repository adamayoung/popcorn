//
//  MediaSearchScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class MediaSearchScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

}

extension MediaSearchScreen {

    private var view: XCUIElement {
        app.scrollViews["media-search.view"]
    }

}
