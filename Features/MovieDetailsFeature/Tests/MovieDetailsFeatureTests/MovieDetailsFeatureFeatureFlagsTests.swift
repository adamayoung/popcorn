//
//  MovieDetailsFeatureFeatureFlagsTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import MovieDetailsFeature
import Testing

@MainActor
@Suite("MovieDetailsFeature updateFeatureFlags Tests")
struct MovieDetailsFeatureFeatureFlagsTests {

    @Test("updateFeatureFlags enables both flags when client returns true")
    func updateFeatureFlagsEnablesBothFlags() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { true }
            $0.movieDetailsClient.isIntelligenceEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isWatchlistEnabled = true
            $0.isIntelligenceEnabled = true
        }
    }

    @Test("updateFeatureFlags disables flags when client returns false")
    func updateFeatureFlagsDisablesFlags() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: true,
                isIntelligenceEnabled: true
            )
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { false }
            $0.movieDetailsClient.isIntelligenceEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isWatchlistEnabled = false
            $0.isIntelligenceEnabled = false
        }
    }

    @Test("updateFeatureFlags defaults to false when client throws")
    func updateFeatureFlagsDefaultsToFalseOnError() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: true,
                isIntelligenceEnabled: true
            )
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { throw TestError.generic }
            $0.movieDetailsClient.isIntelligenceEnabled = { throw TestError.generic }
        }

        await store.send(.updateFeatureFlags) {
            $0.isWatchlistEnabled = false
            $0.isIntelligenceEnabled = false
        }
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
