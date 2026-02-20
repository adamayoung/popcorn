//
//  PopcornUITestCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
class PopcornUITestCase: XCTestCase {

    var app: XCUIApplication!

    var featureFlags: [FeatureFlag: Bool] {
        [:]
    }

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        #if os(iOS)
            XCUIDevice.shared.orientation = .portrait
        #endif
        app = XCUIApplication()
        for (flag, value) in featureFlags {
            app.launchArguments += ["-featureFlagOverride.\(flag.rawValue)", value ? "1" : "0"]
        }
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
