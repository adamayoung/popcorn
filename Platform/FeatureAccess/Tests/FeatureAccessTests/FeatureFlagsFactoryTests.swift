//
//  FeatureFlagsFactoryTests.swift
//  FeatureAccess
//
//  Copyright © 2025 Adam Young.
//

@testable import FeatureAccess
import FeatureAccessTestHelpers
import Testing

@Suite("FeatureFlagsFactory Tests")
struct FeatureFlagsFactoryTests {

    private let factory: FeatureFlagsFactory

    init() {
        let provider = MockFeatureFlagProvider()
        self.factory = FeatureFlagsFactory(provider: provider)
    }

    @Test("makeFeatureFlagService returns a FeatureFlagService")
    func makeFeatureFlagServiceReturnsService() {
        let service = factory.makeFeatureFlagService()

        #expect(!service.isInitialised)
    }

    @Test("makeFeatureFlagService returns service that reports isEnabled")
    func makeFeatureFlagServiceReportsIsEnabled() {
        let service = factory.makeFeatureFlagService()

        #expect(service.isEnabled(.explore) == false)
    }

    @Test("makeFeatureFlagService returns service that supports overrides")
    func makeFeatureFlagServiceSupportsOverrides() {
        let service = factory.makeFeatureFlagService()

        #expect(service.overrideValue(for: .explore) == nil)
    }

}
