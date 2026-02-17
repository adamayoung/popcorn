//
//  FeatureAccessAdaptersFactoryTests.swift
//  FeatureAccessAdapters
//
//  Copyright © 2026 Adam Young.
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

        let service = featureFlagsFactory.featureFlagService

        #expect(!service.isInitialised)
    }

}
