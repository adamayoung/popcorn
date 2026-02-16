//
//  FeatureFlagsFeatureOverrideTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import DeveloperFeature
import Foundation
import TCAFoundation
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

    private static let updatedTestFlag = FeatureFlag(
        id: "test_flag",
        name: "Test Flag",
        description: "A test flag",
        value: true,
        override: .enabled
    )

    @Test("setFeatureFlagOverride with enabled calls client with true")
    func setFeatureFlagOverrideEnabledCallsClientWithTrue() async {
        var receivedValue: Bool?
        let updatedFlags = [Self.updatedTestFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                receivedValue = value
            }
            $0.featureFlagsClient.fetchFeatureFlags = { updatedFlags }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .enabled))
        #expect(receivedValue == true)

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: updatedFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("setFeatureFlagOverride with disabled calls client with false")
    func setFeatureFlagOverrideDisabledCallsClientWithFalse() async {
        var receivedValue: Bool?
        let updatedFlags = [Self.testFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                receivedValue = value
            }
            $0.featureFlagsClient.fetchFeatureFlags = { updatedFlags }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .disabled))
        #expect(receivedValue == false)

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: updatedFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("setFeatureFlagOverride with default calls client with nil")
    func setFeatureFlagOverrideDefaultCallsClientWithNil() async {
        var receivedValue: Bool?
        var wasCalled = false
        let updatedFlags = [Self.testFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                wasCalled = true
                receivedValue = value
            }
            $0.featureFlagsClient.fetchFeatureFlags = { updatedFlags }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .default))
        #expect(wasCalled == true)
        #expect(receivedValue == nil)

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: updatedFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

}
