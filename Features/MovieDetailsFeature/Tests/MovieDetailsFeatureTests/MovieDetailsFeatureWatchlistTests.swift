//
//  MovieDetailsFeatureWatchlistTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import MovieDetailsFeature

@MainActor
@Suite("MovieDetailsFeature toggleOnWatchlist Tests")
struct MovieDetailsFeatureWatchlistTests {

    @Test("toggleOnWatchlist when enabled calls client and sends completed")
    func toggleOnWatchlistWhenEnabledCallsClient() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: true
            )
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.toggleOnWatchlist = { _ in }
        }

        await store.send(.toggleOnWatchlist)

        await store.receive(\.toggleOnWatchlistCompleted)
    }

    @Test("toggleOnWatchlist when disabled does nothing")
    func toggleOnWatchlistWhenDisabledDoesNothing() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: false
            )
        ) {
            MovieDetailsFeature()
        }

        await store.send(.toggleOnWatchlist)
        // No effects expected - TestStore will fail if any effects are produced
    }

    @Test("toggleOnWatchlist failure sends toggleOnWatchlistFailed")
    func toggleOnWatchlistFailureSendsError() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                isWatchlistEnabled: true
            )
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.toggleOnWatchlist = { _ in
                throw TestError.generic
            }
        }

        await store.send(.toggleOnWatchlist)

        await store.receive(\.toggleOnWatchlistFailed)
    }

    @Test("toggleOnWatchlistFailed does not change state")
    func toggleOnWatchlistFailedDoesNotChangeState() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.toggleOnWatchlistFailed(TestError.generic))
    }

    @Test("toggleOnWatchlistCompleted does not change state")
    func toggleOnWatchlistCompletedDoesNotChangeState() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.toggleOnWatchlistCompleted)
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
