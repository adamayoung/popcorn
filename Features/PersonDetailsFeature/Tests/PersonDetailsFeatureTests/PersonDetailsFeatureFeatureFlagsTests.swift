//
//  PersonDetailsFeatureFeatureFlagsTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import PersonDetailsFeature
import Testing

@MainActor
@Suite("PersonDetailsFeature updateFeatureFlags Tests")
struct PersonDetailsFeatureFeatureFlagsTests {

    @Test("updateFeatureFlags enables focalPoint when client returns true")
    func updateFeatureFlagsEnablesFocalPoint() async {
        let store = TestStore(
            initialState: PersonDetailsFeature.State(personID: 123)
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.isFocalPointEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isFocalPointEnabled = true
        }
    }

    @Test("updateFeatureFlags disables focalPoint when client returns false")
    func updateFeatureFlagsDisablesFocalPoint() async {
        let store = TestStore(
            initialState: PersonDetailsFeature.State(
                personID: 123,
                isFocalPointEnabled: true
            )
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.isFocalPointEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isFocalPointEnabled = false
        }
    }

    @Test("updateFeatureFlags defaults to false when client throws")
    func updateFeatureFlagsDefaultsToFalseOnError() async {
        let store = TestStore(
            initialState: PersonDetailsFeature.State(
                personID: 123,
                isFocalPointEnabled: true
            )
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.isFocalPointEnabled = { throw TestError.generic }
        }

        await store.send(.updateFeatureFlags) {
            $0.isFocalPointEnabled = false
        }
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
