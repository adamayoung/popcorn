//
//  AnalyticsServiceTests.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

@testable import Analytics
import Foundation
import Testing

@Suite("AnalyticsService")
struct AnalyticsServiceTests {

    var provider: MockTestAnalyticsProvider
    var service: AnalyticsService

    init() {
        self.provider = MockTestAnalyticsProvider()
        self.service = AnalyticsService(provider: provider)
    }

    @Test("start delegates to provider")
    func startDelegatesToProvider() async throws {
        let config = AnalyticsConfiguration(
            apiKey: "test-key",
            environment: .development,
            userID: "user-123"
        )

        try await service.start(config)

        #expect(provider.startCallCount == 1)
        #expect(provider.lastStartConfig?.apiKey == "test-key")
        #expect(provider.lastStartConfig?.environment == .development)
        #expect(provider.lastStartConfig?.userID == "user-123")
    }

    @Test("track delegates to provider when initialised")
    func trackDelegatesToProvider() {
        provider.isInitialised = true

        service.track(event: "button_clicked", properties: ["screen": "home"])

        #expect(provider.trackCallCount == 1)
        #expect(provider.lastTrackedEvent == "button_clicked")
    }

    @Test("track does not delegate when not initialised")
    func trackGuardsInitialisation() {
        provider.isInitialised = false

        service.track(event: "button_clicked", properties: nil)

        #expect(provider.trackCallCount == 0)
    }

    @Test("track with nil properties delegates correctly")
    func trackWithNilProperties() {
        provider.isInitialised = true

        service.track(event: "app_opened", properties: nil)

        #expect(provider.trackCallCount == 1)
        #expect(provider.lastTrackedEvent == "app_opened")
    }

    @Test("setUserId delegates to provider when initialised")
    func setUserIdDelegatesToProvider() {
        provider.isInitialised = true

        service.setUserId("user-456")

        #expect(provider.setUserIdCallCount == 1)
        #expect(provider.lastUserId == "user-456")
    }

    @Test("setUserId does not delegate when not initialised")
    func setUserIdGuardsInitialisation() {
        provider.isInitialised = false

        service.setUserId("user-456")

        #expect(provider.setUserIdCallCount == 0)
    }

    @Test("setUserId with nil delegates correctly")
    func setUserIdWithNil() {
        provider.isInitialised = true

        service.setUserId(nil)

        #expect(provider.setUserIdCallCount == 1)
    }

    @Test("setUserProperties delegates to provider when initialised")
    func setUserPropertiesDelegatesToProvider() {
        provider.isInitialised = true

        service.setUserProperties(["plan": "premium", "age": 25])

        #expect(provider.setUserPropertiesCallCount == 1)
    }

    @Test("setUserProperties does not delegate when not initialised")
    func setUserPropertiesGuardsInitialisation() {
        provider.isInitialised = false

        service.setUserProperties(["plan": "premium"])

        #expect(provider.setUserPropertiesCallCount == 0)
    }

    @Test("reset delegates to provider when initialised")
    func resetDelegatesToProvider() {
        provider.isInitialised = true

        service.reset()

        #expect(provider.resetCallCount == 1)
    }

    @Test("reset does not delegate when not initialised")
    func resetGuardsInitialisation() {
        provider.isInitialised = false

        service.reset()

        #expect(provider.resetCallCount == 0)
    }

}

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
