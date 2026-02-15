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
