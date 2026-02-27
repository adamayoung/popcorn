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
        let receivedValue = LockIsolated<Bool?>(nil)
        let updatedFlags = [Self.updatedTestFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                receivedValue.withValue { $0 = value }
            }
            $0.featureFlagsClient.fetchFeatureFlags = { updatedFlags }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .enabled))
        receivedValue.withValue { #expect($0 == true) }

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: updatedFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("setFeatureFlagOverride with disabled calls client with false")
    func setFeatureFlagOverrideDisabledCallsClientWithFalse() async {
        let receivedValue = LockIsolated<Bool?>(nil)
        let updatedFlags = [Self.testFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                receivedValue.withValue { $0 = value }
            }
            $0.featureFlagsClient.fetchFeatureFlags = { updatedFlags }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .disabled))
        receivedValue.withValue { #expect($0 == false) }

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: updatedFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("setFeatureFlagOverride with default calls client with nil")
    func setFeatureFlagOverrideDefaultCallsClientWithNil() async {
        let receivedValue = LockIsolated<Bool?>(nil)
        let wasCalled = LockIsolated(false)
        let updatedFlags = [Self.testFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.updateFeatureFlagValue = { _, value in
                wasCalled.withValue { $0 = true }
                receivedValue.withValue { $0 = value }
            }
            $0.featureFlagsClient.fetchFeatureFlags = { updatedFlags }
        }

        await store.send(.setFeatureFlagOverride(Self.testFlag, .default))
        wasCalled.withValue { #expect($0 == true) }
        receivedValue.withValue { #expect($0 == nil) }

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: updatedFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("resetAllOverrides calls removeAllOverrides and re-fetches flags")
    func resetAllOverridesCallsRemoveAllOverridesAndRefetches() async {
        let removeAllOverridesCalled = LockIsolated(false)
        let flags = [Self.testFlag]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.removeAllOverrides = {
                removeAllOverridesCalled.withValue { $0 = true }
            }
            $0.featureFlagsClient.fetchFeatureFlags = { flags }
        }

        await store.send(.resetAllOverrides)
        removeAllOverridesCalled.withValue { #expect($0 == true) }

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: flags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

}
