//
//  AmplitudeAnalyticsProviderTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Analytics
@testable import AnalyticsAdapters
import Foundation
import Testing

@Suite("AmplitudeAnalyticsProvider")
struct AmplitudeAnalyticsProviderTests {

    @Test("isInitialised is false before start")
    func isInitialisedIsFalseBeforeStart() {
        let provider = AmplitudeAnalyticsProvider()

        #expect(!provider.isInitialised)
    }

    @Test("isInitialised is true after start")
    func isInitialisedIsTrueAfterStart() async throws {
        let provider = AmplitudeAnalyticsProvider()
        let config = AnalyticsConfiguration(
            apiKey: "test-key",
            environment: .development,
            userID: "user-123"
        )

        try await provider.start(config)

        #expect(provider.isInitialised)
    }

    @Test("track does not crash before start")
    func trackDoesNotCrashBeforeStart() {
        let provider = AmplitudeAnalyticsProvider()

        provider.track(event: "test_event", properties: nil)
    }

    @Test("setUserId does not crash before start")
    func setUserIdDoesNotCrashBeforeStart() {
        let provider = AmplitudeAnalyticsProvider()

        provider.setUserId("user-456")
    }

    @Test("setUserProperties does not crash before start")
    func setUserPropertiesDoesNotCrashBeforeStart() {
        let provider = AmplitudeAnalyticsProvider()

        provider.setUserProperties(["key": "value"])
    }

    @Test("reset does not crash before start")
    func resetDoesNotCrashBeforeStart() {
        let provider = AmplitudeAnalyticsProvider()

        provider.reset()
    }

}
