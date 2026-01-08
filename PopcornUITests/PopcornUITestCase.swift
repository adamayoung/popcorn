//
//  PopcornUITestCase.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
//

import XCTest

class PopcornUITestCase: XCTestCase {

    var app: XCUIApplication!

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
#if os(iOS)
        XCUIDevice.shared.orientation = .portrait
#endif
        app = XCUIApplication()
        app.launchArguments = ["-uitest"]
        app.launch()
    }

    @MainActor
    override func tearDown() async throws {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .deleteOnSuccess
        add(attachment)
        app.terminate()
        try await super.tearDown()
    }

}
