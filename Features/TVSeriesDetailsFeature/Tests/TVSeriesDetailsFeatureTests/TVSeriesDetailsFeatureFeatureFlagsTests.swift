//
//  TVSeriesDetailsFeatureFeatureFlagsTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import TVSeriesDetailsFeature

@MainActor
@Suite("TVSeriesDetailsFeature updateFeatureFlags Tests")
struct TVSeriesDetailsFeatureFeatureFlagsTests {

    @Test("updateFeatureFlags enables all flags when client returns true")
    func updateFeatureFlagsEnablesAllFlags() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 123)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { true }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { true }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = true
            $0.isIntelligenceEnabled = true
            $0.isBackdropFocalPointEnabled = true
        }
    }

    @Test("updateFeatureFlags disables all flags when client returns false")
    func updateFeatureFlagsDisablesAllFlags() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(
                tvSeriesID: 123,
                isCastAndCrewEnabled: true,
                isIntelligenceEnabled: true,
                isBackdropFocalPointEnabled: true
            )
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = false
            $0.isIntelligenceEnabled = false
            $0.isBackdropFocalPointEnabled = false
        }
    }

    @Test("updateFeatureFlags defaults to false when client throws")
    func updateFeatureFlagsDefaultsToFalseOnError() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(
                tvSeriesID: 123,
                isCastAndCrewEnabled: true,
                isIntelligenceEnabled: true,
                isBackdropFocalPointEnabled: true
            )
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { throw TestError.generic }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { throw TestError.generic }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { throw TestError.generic }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = false
            $0.isIntelligenceEnabled = false
            $0.isBackdropFocalPointEnabled = false
        }
    }

    @Test("updateFeatureFlags enables only backdropFocalPoint when others disabled")
    func updateFeatureFlagsEnablesOnlyBackdropFocalPoint() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 123)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isBackdropFocalPointEnabled = true
        }
    }

    @Test("updateFeatureFlags enables only intelligence when others disabled")
    func updateFeatureFlagsEnablesOnlyIntelligence() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 123)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { true }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isIntelligenceEnabled = true
        }
    }

    @Test("updateFeatureFlags enables only castAndCrew when others disabled")
    func updateFeatureFlagsEnablesOnlyCastAndCrew() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 123)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { true }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = true
        }
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
