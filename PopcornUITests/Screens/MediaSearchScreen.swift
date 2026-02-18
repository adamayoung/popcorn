//
//  MediaSearchScreen.swift
//  Popcorn
//
//  Created by Adam Young on 18/02/2026.
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
