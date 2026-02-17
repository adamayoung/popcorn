//
//  MovieDetailsFeatureFeatureFlagsTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import MovieDetailsFeature
import Testing

@MainActor
@Suite("MovieDetailsFeature updateFeatureFlags Tests")
struct MovieDetailsFeatureFeatureFlagsTests {

    @Test("updateFeatureFlags enables all flags when client returns true")
    func updateFeatureFlagsEnablesAllFlags() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { true }
            $0.movieDetailsClient.isIntelligenceEnabled = { true }
            $0.movieDetailsClient.isBackdropFocalPointEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isWatchlistEnabled = true
            $0.isIntelligenceEnabled = true
            $0.isBackdropFocalPointEnabled = true
        }
    }

    @Test("updateFeatureFlags disables all flags when client returns false")
    func updateFeatureFlagsDisablesAllFlags() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: true,
                isIntelligenceEnabled: true,
                isBackdropFocalPointEnabled: true
            )
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { false }
            $0.movieDetailsClient.isIntelligenceEnabled = { false }
            $0.movieDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isWatchlistEnabled = false
            $0.isIntelligenceEnabled = false
            $0.isBackdropFocalPointEnabled = false
        }
    }

    @Test("updateFeatureFlags defaults to false when client throws")
    func updateFeatureFlagsDefaultsToFalseOnError() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: true,
                isIntelligenceEnabled: true,
                isBackdropFocalPointEnabled: true
            )
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { throw TestError.generic }
            $0.movieDetailsClient.isIntelligenceEnabled = { throw TestError.generic }
            $0.movieDetailsClient.isBackdropFocalPointEnabled = { throw TestError.generic }
        }

        await store.send(.updateFeatureFlags) {
            $0.isWatchlistEnabled = false
            $0.isIntelligenceEnabled = false
            $0.isBackdropFocalPointEnabled = false
        }
    }

    @Test("updateFeatureFlags enables only backdropFocalPoint when others disabled")
    func updateFeatureFlagsEnablesOnlyBackdropFocalPoint() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { false }
            $0.movieDetailsClient.isIntelligenceEnabled = { false }
            $0.movieDetailsClient.isBackdropFocalPointEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isBackdropFocalPointEnabled = true
        }
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
