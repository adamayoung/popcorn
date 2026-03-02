//
//  AnalyticsFactoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import Analytics
import Foundation
import Testing

@Suite("AnalyticsFactory")
struct AnalyticsFactoryTests {

    @Test("makeService returns a service that can track events")
    func makeServiceCanTrackEvents() {
        let provider = MockTestAnalyticsProvider()
        provider.isInitialised = true
        let factory = AnalyticsFactory(provider: provider)

        let service = factory.makeService()
        service.track(event: "test_event", properties: nil)

        #expect(provider.trackCallCount == 1)
    }

    @Test("makeService returns a service that can be started")
    func makeServiceCanBeStarted() async throws {
        let provider = MockTestAnalyticsProvider()
        let factory = AnalyticsFactory(provider: provider)

        let service = factory.makeService()
        let config = AnalyticsConfiguration(
            apiKey: "key",
            environment: .development,
            userID: "user"
        )
        try await service.start(config)

        #expect(provider.startCallCount == 1)
    }

}
