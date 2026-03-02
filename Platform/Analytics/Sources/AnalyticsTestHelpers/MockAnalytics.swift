//
//  MockAnalytics.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

import Analytics
import Foundation

public final class MockAnalytics: Analysing, @unchecked Sendable {

    public private(set) var trackCallCount = 0
    public private(set) var trackedEvents: [(event: String, properties: [String: any Sendable]?)] = []

    public private(set) var setUserIdCallCount = 0
    public private(set) var lastUserId: String?

    public private(set) var setUserPropertiesCallCount = 0
    public private(set) var lastUserProperties: [String: any Sendable]?

    public private(set) var resetCallCount = 0

    public init() {}

    public func track(event: String, properties: [String: any Sendable]?) {
        trackCallCount += 1
        trackedEvents.append((event: event, properties: properties))
    }

    public func setUserId(_ userId: String?) {
        setUserIdCallCount += 1
        lastUserId = userId
    }

    public func setUserProperties(_ properties: [String: any Sendable]) {
        setUserPropertiesCallCount += 1
        lastUserProperties = properties
    }

    public func reset() {
        resetCallCount += 1
    }

}
