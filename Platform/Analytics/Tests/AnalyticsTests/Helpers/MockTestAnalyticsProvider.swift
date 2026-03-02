//
//  MockTestAnalyticsProvider.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

@testable import Analytics
import Foundation

final class MockTestAnalyticsProvider: AnalyticsProviding, @unchecked Sendable {

    var isInitialised: Bool = false

    var startCallCount = 0
    var lastStartConfig: AnalyticsConfiguration?

    var trackCallCount = 0
    var lastTrackedEvent: String?
    var lastTrackedProperties: [String: any Sendable]?

    var setUserIdCallCount = 0
    var lastUserId: String?

    var setUserPropertiesCallCount = 0
    var lastUserProperties: [String: any Sendable]?

    var resetCallCount = 0

    func start(_ config: AnalyticsConfiguration) async throws {
        startCallCount += 1
        lastStartConfig = config
    }

    func track(event: String, properties: [String: any Sendable]?) {
        trackCallCount += 1
        lastTrackedEvent = event
        lastTrackedProperties = properties
    }

    func setUserId(_ userId: String?) {
        setUserIdCallCount += 1
        lastUserId = userId
    }

    func setUserProperties(_ properties: [String: any Sendable]) {
        setUserPropertiesCallCount += 1
        lastUserProperties = properties
    }

    func reset() {
        resetCallCount += 1
    }

}
