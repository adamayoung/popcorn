//
//  MovieDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class MovieDetailsScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

    func assertMovieTitle(_ title: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(contentView(withTitle: title).waitForExistence(timeout: 5), file: file, line: line)
    }

    func isOnWatchlist() -> Bool {
        removeFromWatchlistButton.exists
    }

    func tapAddToWatchlist() {
        addToWatchlistButton.tap()
    }

    func tapRemoveFromWatchlist() {
        removeFromWatchlistButton.tap()
    }

}

extension MovieDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["movie-details.view"]
    }

    private func contentView(withTitle title: String) -> XCUIElement {
        app.navigationBars.staticTexts[title]
    }

    private var addToWatchlistButton: XCUIElement {
        app.buttons["movie-details.watchlist-toggle.off"]
    }

    private var removeFromWatchlistButton: XCUIElement {
        app.buttons["movie-details.watchlist-toggle.on"]
    }

}
