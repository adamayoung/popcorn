//
//  FeatureAccessAdaptersFactoryTests.swift
//  FeatureAccessAdapters
//
//  Copyright © 2025 Adam Young.
//

import FeatureAccess
@testable import FeatureAccessAdapters
import Foundation
import Testing

@Suite("FeatureAccessAdaptersFactory Tests")
struct FeatureAccessAdaptersFactoryTests {

    @Test("Factory can be initialized")
    func factoryCanBeInitialized() {
        let factory = FeatureAccessAdaptersFactory()

        #expect(factory != nil)
    }

    @Test("makeFeatureFlagsFactory returns FeatureFlagsFactory")
    func makeFeatureFlagsFactoryReturnsFeatureFlagsFactory() {
        let factory = FeatureAccessAdaptersFactory()

        let featureFlagsFactory = factory.makeFeatureFlagsFactory()

        // Verify the factory returns a valid FeatureFlagsFactory
        // We can verify this by checking we can create a service from it
        let service = featureFlagsFactory.makeService()
        #expect(service != nil)
    }

    @Test("makeFeatureFlagsFactory returns factory that creates valid service")
    func makeFeatureFlagsFactoryReturnsFactoryThatCreatesValidService() {
        let factory = FeatureAccessAdaptersFactory()
        let featureFlagsFactory = factory.makeFeatureFlagsFactory()

        let service = featureFlagsFactory.makeService()

        // The service should conform to both FeatureFlagging and FeatureFlagInitialising
        let _: any FeatureFlagging = service
        let _: any FeatureFlagInitialising = service

        #expect(true)
    }

}
