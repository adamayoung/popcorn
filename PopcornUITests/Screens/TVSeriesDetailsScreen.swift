//
//  TVSeriesDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class TVSeriesDetailsScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

    func assertTVSeriesName(_ name: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(contentView(withTitle: name).waitForExistence(timeout: 5), file: file, line: line)
    }

    @discardableResult
    func tapOnSeason(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> TVSeasonDetailsScreen {
        scrollTo(seasonsCarousel)
        XCTAssertTrue(seasonsCarousel.waitForExistence(timeout: 2), file: file, line: line)
        season(at: index).tap()
        return TVSeasonDetailsScreen(app: app, file: file, line: line)
    }

}

extension TVSeriesDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["tv-series-details.view"]
    }

    private func contentView(withTitle title: String) -> XCUIElement {
        app.navigationBars.staticTexts[title]
    }

    private var seasonsCarousel: XCUIElement {
        app.scrollViews["tv-series-details.seasons.carousel"]
    }

    private func season(at index: Int) -> XCUIElement {
        app.buttons["tv-series-details.seasons.season.\(index)"]
    }

}
