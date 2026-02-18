//
//  TVSeriesDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class TVSeriesDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

    func assertTVSeriesName(_ name: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(contentView(withTitle: name).waitForExistence(timeout: 5), file: file, line: line)
    }

}

extension TVSeriesDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["tv-series-details.view"]
    }

    private func contentView(withTitle title: String) -> XCUIElement {
        app.navigationBars.staticTexts[title]
    }

}
