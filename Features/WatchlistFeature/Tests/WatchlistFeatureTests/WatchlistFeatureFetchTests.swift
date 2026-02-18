//
//  WatchlistFeatureFetchTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
@testable import WatchlistFeature

@MainActor
@Suite("WatchlistFeature fetch Tests")
struct WatchlistFeatureFetchTests {

    @Test("fetch sets loading state")
    func fetchSetsLoadingState() async {
        let movies = [
            MoviePreview(id: 1, title: "Movie 1"),
            MoviePreview(id: 2, title: "Movie 2")
        ]

        let store = TestStore(
            initialState: WatchlistFeature.State()
        ) {
            WatchlistFeature()
        } withDependencies: {
            $0.watchlistClient.fetchWatchlistMovies = { movies }
            $0.watchlistClient.streamWatchlistMovies = {
                AsyncThrowingStream { $0.finish() }
            }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.moviesLoaded) {
            $0.viewState = .ready(
                WatchlistFeature.ViewSnapshot(movies: movies)
            )
        }
    }

    @Test("moviesLoaded sets ready state with movies")
    func moviesLoadedSetsReadyState() async {
        let movies = [
            MoviePreview(id: 1, title: "Movie 1"),
            MoviePreview(id: 2, title: "Movie 2")
        ]

        let store = TestStore(
            initialState: WatchlistFeature.State(viewState: .loading)
        ) {
            WatchlistFeature()
        }

        await store.send(.moviesLoaded(movies)) {
            $0.viewState = .ready(
                WatchlistFeature.ViewSnapshot(movies: movies)
            )
        }
    }

    @Test("moviesUpdated updates ready state with new movies")
    func moviesUpdatedUpdatesReadyState() async {
        let initialMovies = [MoviePreview(id: 1, title: "Movie 1")]
        let updatedMovies = [
            MoviePreview(id: 1, title: "Movie 1"),
            MoviePreview(id: 2, title: "Movie 2")
        ]

        let store = TestStore(
            initialState: WatchlistFeature.State(
                viewState: .ready(
                    WatchlistFeature.ViewSnapshot(movies: initialMovies)
                )
            )
        ) {
            WatchlistFeature()
        }

        await store.send(.moviesUpdated(updatedMovies)) {
            $0.viewState = .ready(
                WatchlistFeature.ViewSnapshot(movies: updatedMovies)
            )
        }
    }

    @Test("moviesUpdated is ignored when not in ready state")
    func moviesUpdatedIsIgnoredWhenNotReady() async {
        let store = TestStore(
            initialState: WatchlistFeature.State(viewState: .loading)
        ) {
            WatchlistFeature()
        }

        await store.send(.moviesUpdated([MoviePreview(id: 1, title: "Movie 1")]))
    }

    @Test("fetch streams updates after initial load")
    func fetchStreamsUpdatesAfterInitialLoad() async {
        let movies = [MoviePreview(id: 1, title: "Movie 1")]
        let updatedMovies = [
            MoviePreview(id: 1, title: "Movie 1"),
            MoviePreview(id: 2, title: "Movie 2")
        ]

        let store = TestStore(
            initialState: WatchlistFeature.State()
        ) {
            WatchlistFeature()
        } withDependencies: {
            $0.watchlistClient.fetchWatchlistMovies = { movies }
            $0.watchlistClient.streamWatchlistMovies = {
                AsyncThrowingStream { continuation in
                    continuation.yield(updatedMovies)
                    continuation.finish()
                }
            }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.moviesLoaded) {
            $0.viewState = .ready(
                WatchlistFeature.ViewSnapshot(movies: movies)
            )
        }

        await store.receive(\.moviesUpdated) {
            $0.viewState = .ready(
                WatchlistFeature.ViewSnapshot(movies: updatedMovies)
            )
        }
    }

    @Test("loadFailed sets error state")
    func loadFailedSetsErrorState() async {
        let error = ViewStateError(message: "Something went wrong")

        let store = TestStore(
            initialState: WatchlistFeature.State(viewState: .loading)
        ) {
            WatchlistFeature()
        }

        await store.send(.loadFailed(error)) {
            $0.viewState = .error(error)
        }
    }

}
