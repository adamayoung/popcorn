//
//  WatchlistScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class WatchlistScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

    func assertMovieExists(withTitle title: String, file: StaticString = #filePath, line: UInt = #line) {
        let movie = movie(withTitle: title)
        XCTAssertTrue(movie.waitForExistence(timeout: 2), file: file, line: line)
    }

    func assertMovieDoesNotExist(withTitle title: String, file: StaticString = #filePath, line: UInt = #line) {
        let movie = movie(withTitle: title)
        XCTAssertFalse(movie.waitForExistence(timeout: 2), file: file, line: line)
    }

    func movieTitle(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> String {
        let movie = movie(at: index)
        XCTAssertTrue(movie.waitForExistence(timeout: 2), file: file, line: line)
        return movie.label
    }

    @discardableResult
    func tapOnMovie(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> MovieDetailsScreen {
        let movie = movie(at: index)
        scrollTo(movie)
        XCTAssertTrue(movie.waitForExistence(timeout: 2), file: file, line: line)
        movie.tap()
        return MovieDetailsScreen(app: app, file: file, line: line)
    }

}

extension WatchlistScreen {

    private var view: XCUIElement {
        app.scrollViews["watchlist.view"]
    }

    private func movie(at index: Int) -> XCUIElement {
        view.buttons["watchlist.movie.\(index)"]
    }

    private func movie(withTitle title: String) -> XCUIElement {
        view.buttons[title]
    }

}
