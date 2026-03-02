//
//  AnalyticsAdaptersFactoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Analytics
@testable import AnalyticsAdapters
import Foundation
import Testing

@Suite("AnalyticsAdaptersFactory")
struct AnalyticsAdaptersFactoryTests {

    @Test("makeAnalyticsFactory returns a factory that creates a usable service")
    func makeAnalyticsFactoryCreatesUsableService() async throws {
        let factory = AnalyticsAdaptersFactory()
        let analyticsFactory = factory.makeAnalyticsFactory()

        let service = analyticsFactory.makeService()
        let config = AnalyticsConfiguration(
            apiKey: "test-key",
            environment: .development,
            userID: "user-123"
        )
        try await service.start(config)

        // Service should be able to track events after starting
        service.track(event: "test", properties: nil)
    }

}
