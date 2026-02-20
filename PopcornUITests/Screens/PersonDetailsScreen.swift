//
//  PersonDetailsScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class PersonDetailsScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

    func assertPersonName(_ name: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(contentView(withTitle: name).waitForExistence(timeout: 5), file: file, line: line)
    }

}

extension PersonDetailsScreen {

    private var view: XCUIElement {
        app.scrollViews["person-details.view"]
    }

    private func contentView(withTitle title: String) -> XCUIElement {
        app.navigationBars.staticTexts[title]
    }

}
