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

    func assertMovieTitle(_ title: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(contentView(withTitle: title).waitForExistence(timeout: 5), file: file, line: line)
    }

}

extension MovieDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["movie-details.view"]
    }

    private func contentView(withTitle title: String) -> XCUIElement {
        app.navigationBars.staticTexts[title]
    }

}
