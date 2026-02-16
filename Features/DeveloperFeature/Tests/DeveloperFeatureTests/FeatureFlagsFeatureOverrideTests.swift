//
//  FeatureFlagsFeatureOverrideTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import DeveloperFeature
import Foundation
import Testing

@MainActor
@Suite("FeatureFlagsFeature setFeatureFlagOverride Tests")
struct FeatureFlagsFeatureOverrideTests {

    private static let testFlag = FeatureFlag(
        id: "test_flag",
        name: "Test Flag",
        description: "A test flag",
        value: true,
        override: .default
    )

    @Test("setFeatureFlagOverride with enabled calls client with true")
    func setFeatureFlagOverrideEnabledCallsClientWithTrue() async {
        var receivedValue: Bool?

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                receivedValue = value
            }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .enabled))
        #expect(receivedValue == true)
    }

    @Test("setFeatureFlagOverride with disabled calls client with false")
    func setFeatureFlagOverrideDisabledCallsClientWithFalse() async {
        var receivedValue: Bool?

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                receivedValue = value
            }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .disabled))
        #expect(receivedValue == false)
    }

    @Test("setFeatureFlagOverride with default calls client with nil")
    func setFeatureFlagOverrideDefaultCallsClientWithNil() async {
        var receivedValue: Bool?
        var wasCalled = false

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                wasCalled = true
                receivedValue = value
            }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .default))
        #expect(wasCalled == true)
        #expect(receivedValue == nil)
    }

}
