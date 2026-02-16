//
//  FeatureFlagsFeatureLoadTests.swift
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
@Suite("FeatureFlagsFeature load Tests")
struct FeatureFlagsFeatureLoadTests {

    @Test("load transitions to loading and emits loaded on success")
    func loadTransitionsToLoadingAndEmitsLoaded() async {
        let featureFlags: [FeatureFlag] = [
            FeatureFlag(
                id: "test_flag",
                name: "Test Flag",
                description: "A test flag",
                value: true,
                override: .default
            )
        ]

        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.fetchFeatureFlags = { featureFlags }
        }

        await store.send(.load) {
            $0.viewState = .loading
        }

        let expectedSnapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: featureFlags)
        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("load emits loadFailed on error")
    func loadEmitsLoadFailedOnError() async {
        let store = TestStore(
            initialState: FeatureFlagsFeature.State()
        ) {
            FeatureFlagsFeature()
        } withDependencies: {
            $0.featureFlagsClient.fetchFeatureFlags = { throw TestError.fetchFailed }
        }

        await store.send(.load) {
            $0.viewState = .loading
        }

        await store.receive(\.loadFailed) {
            $0.viewState = .error(ViewStateError(TestError.fetchFailed))
        }
    }

    @Test("load when already ready does nothing")
    func loadWhenAlreadyReadyDoesNothing() async {
        let snapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: [])

        let store = TestStore(
            initialState: FeatureFlagsFeature.State(viewState: .ready(snapshot))
        ) {
            FeatureFlagsFeature()
        }

        await store.send(.load)
    }

    @Test("loaded sets viewState to ready with snapshot")
    func loadedSetsViewStateToReady() async {
        let featureFlags: [FeatureFlag] = [
            FeatureFlag(
                id: "flag_1",
                name: "Flag 1",
                description: "Description",
                value: false,
                override: .enabled
            )
        ]
        let snapshot = FeatureFlagsFeature.ViewSnapshot(featureFlags: featureFlags)

        let store = TestStore(
            initialState: FeatureFlagsFeature.State(viewState: .loading)
        ) {
            FeatureFlagsFeature()
        }

        await store.send(.loaded(snapshot)) {
            $0.viewState = .ready(snapshot)
        }
    }

    @Test("loadFailed sets viewState to error")
    func loadFailedSetsViewStateToError() async {
        let error = ViewStateError(message: "Something went wrong")

        let store = TestStore(
            initialState: FeatureFlagsFeature.State(viewState: .loading)
        ) {
            FeatureFlagsFeature()
        }

        await store.send(.loadFailed(error)) {
            $0.viewState = .error(error)
        }
    }

}

// MARK: - Test Helpers

private enum TestError: Error {
    case fetchFailed
}
