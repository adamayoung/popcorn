//
//  FeatureFlagsFactoryTests.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
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

    @Test("featureFlagService returns a FeatureFlagService")
    func featureFlagServiceReturnsService() {
        let service = factory.featureFlagService

        #expect(!service.isInitialised)
    }

    @Test("featureFlagService returns service that reports isEnabled")
    func featureFlagServiceReportsIsEnabled() {
        let service = factory.featureFlagService

        #expect(service.isEnabled(.explore) == false)
    }

    @Test("featureFlagService returns service that supports overrides")
    func featureFlagServiceSupportsOverrides() {
        let service = factory.featureFlagService

        #expect(service.overrideValue(for: .explore) == nil)
    }

}
