//
//  FeatureFlagOverrideStateTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

@testable import DeveloperFeature
import Testing

@Suite("FeatureFlagOverrideState Tests")
struct FeatureFlagOverrideStateTests {

    @Test("default value returns nil")
    func defaultValueReturnsNil() {
        #expect(FeatureFlagOverrideState.default.value == nil)
    }

    @Test("enabled value returns true")
    func enabledValueReturnsTrue() {
        #expect(FeatureFlagOverrideState.enabled.value == true)
    }

    @Test("disabled value returns false")
    func disabledValueReturnsFalse() {
        #expect(FeatureFlagOverrideState.disabled.value == false)
    }

    @Test("init with nil returns default")
    func initWithNilReturnsDefault() {
        #expect(FeatureFlagOverrideState(value: nil) == .default)
    }

    @Test("init with true returns enabled")
    func initWithTrueReturnsEnabled() {
        #expect(FeatureFlagOverrideState(value: true) == .enabled)
    }

    @Test("init with false returns disabled")
    func initWithFalseReturnsDisabled() {
        #expect(FeatureFlagOverrideState(value: false) == .disabled)
    }

}
