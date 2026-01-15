//
//  MovieDetailsFeatureDidAppearTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import MovieDetailsFeature

@MainActor
@Suite("MovieDetailsFeature didAppear Tests")
struct MovieDetailsFeatureDidAppearTests {

    @Test("didAppear triggers updateFeatureFlags")
    func didAppearTriggersUpdateFeatureFlags() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isWatchlistEnabled = { true }
            $0.movieDetailsClient.isIntelligenceEnabled = { false }
        }

        await store.send(.didAppear)

        await store.receive(\.updateFeatureFlags) {
            $0.isWatchlistEnabled = true
            $0.isIntelligenceEnabled = false
        }
    }

}
