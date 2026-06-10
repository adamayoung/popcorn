//
//  FeatureFlagMapperTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import DeveloperFeature
import FeatureAccess
import Testing

@Suite("FeatureFlagMapper Tests")
struct FeatureFlagMapperTests {

    private let mapper = FeatureFlagMapper()

    @Test("maps all properties correctly")
    func mapsAllProperties() {
        let source = FeatureAccess.FeatureFlag.explore

        let result = mapper.map(source, value: true, overrideValue: nil)

        #expect(result.id == source.id)
        #expect(result.name == source.name)
        #expect(result.description == source.description)
        #expect(result.value == true)
        #expect(result.override == .default)
    }

    @Test("maps with override value true to enabled")
    func mapsWithOverrideTrueToEnabled() {
        let source = FeatureAccess.FeatureFlag.explore

        let result = mapper.map(source, value: false, overrideValue: true)

        #expect(result.override == .enabled)
    }

    @Test("maps with override value false to disabled")
    func mapsWithOverrideFalseToDisabled() {
        let source = FeatureAccess.FeatureFlag.explore

        let result = mapper.map(source, value: true, overrideValue: false)

        #expect(result.override == .disabled)
    }

    @Test("maps with override value nil to default")
    func mapsWithOverrideNilToDefault() {
        let source = FeatureAccess.FeatureFlag.explore

        let result = mapper.map(source, value: true, overrideValue: nil)

        #expect(result.override == .default)
    }

}
