//
//  Screen.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
//

import XCTest

@MainActor
class Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        fatalError("uniqueElement not implemented")
    }

    init(app: XCUIApplication) {
        self.app = app
        assertScreenExists()
    }

    func assertScreenExists() {
        XCTAssertTrue(uniqueElement.exists, "App is expecting to be on \(String(describing: type(of: self)))")
    }

    // MARK: - Scrolling

    /// Scrolls down within the unique element
    func scrollDown() {
        uniqueElement.swipeUp()
    }

    /// Scrolls up within the unique element
    func scrollUp() {
        uniqueElement.swipeDown()
    }

    /// Scrolls until the specified element is visible or max attempts reached
    /// - Parameters:
    ///   - element: The element to scroll to
    ///   - direction: The scroll direction (.up or .down)
    ///   - maxAttempts: Maximum number of scroll attempts
    /// - Returns: Whether the element was found
    @discardableResult
    func scrollTo(
        _ element: XCUIElement,
        direction: ScrollDirection = .down,
        maxAttempts: Int = 5
    ) -> Bool {
        var attempts = 0
        while !element.isHittable && attempts < maxAttempts {
            switch direction {
            case .up:
                scrollUp()
            case .down:
                scrollDown()
            }
            attempts += 1
        }
        return element.isHittable
    }

    /// Scrolls until the element is visible, then waits for it to exist
    /// - Parameters:
    ///   - element: The element to scroll to and wait for
    ///   - direction: The scroll direction
    ///   - timeout: How long to wait for element existence after scrolling
    ///   - maxAttempts: Maximum scroll attempts
    /// - Returns: Whether the element exists and is hittable
    @discardableResult
    func scrollToAndWait(
        _ element: XCUIElement,
        direction: ScrollDirection = .down,
        timeout: TimeInterval = 2,
        maxAttempts: Int = 5
    ) -> Bool {
        if element.isHittable {
            return true
        }

        for _ in 0..<maxAttempts {
            switch direction {
            case .up:
                scrollUp()
            case .down:
                scrollDown()
            }

            if element.waitForExistence(timeout: timeout) && element.isHittable {
                return true
            }
        }
        return false
    }

}

// MARK: - ScrollDirection

enum ScrollDirection {
    case up
    case down
}
