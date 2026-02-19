//
//  MovieDetailsFeatureFetchFeatureFlagsTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import MovieDetailsFeature
import TCAFoundation
import Testing

@MainActor
@Suite("MovieDetailsFeature fetch feature flag Tests")
struct MovieDetailsFeatureFetchFeatureFlagsTests {

    @Test("fetch skips credits when castAndCrew flag disabled")
    func fetchSkipsCreditsWhenFlagDisabled() async {
        let movie = Self.testMovie
        let recommendations = Self.testRecommendations

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { false }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { true }
            $0.movieDetailsClient.fetchMovie = { _ in movie }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { $0.finish() }
            }
            $0.movieDetailsClient.fetchRecommendedMovies = { _ in recommendations }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(MovieDetailsFeature.ViewSnapshot(
                movie: movie,
                recommendedMovies: recommendations,
                castMembers: [],
                crewMembers: []
            ))
        }
    }

    @Test("fetch skips recommendations when flag disabled")
    func fetchSkipsRecommendationsWhenFlagDisabled() async {
        let movie = Self.testMovie
        let credits = Self.testCredits

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { true }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { false }
            $0.movieDetailsClient.fetchMovie = { _ in movie }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { $0.finish() }
            }
            $0.movieDetailsClient.fetchCredits = { _ in credits }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(MovieDetailsFeature.ViewSnapshot(
                movie: movie,
                recommendedMovies: [],
                castMembers: credits.castMembers,
                crewMembers: credits.crewMembers
            ))
        }
    }

    @Test("fetch skips both credits and recommendations when both flags disabled")
    func fetchSkipsBothWhenBothFlagsDisabled() async {
        let movie = Self.testMovie

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { false }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { false }
            $0.movieDetailsClient.fetchMovie = { _ in movie }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { $0.finish() }
            }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(MovieDetailsFeature.ViewSnapshot(
                movie: movie,
                recommendedMovies: [],
                castMembers: [],
                crewMembers: []
            ))
        }
    }

    @Test("fetch defaults to skipping when flag evaluation throws")
    func fetchDefaultsToSkippingWhenFlagEvaluationThrows() async {
        let movie = Self.testMovie

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { throw FlagError.unavailable }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { throw FlagError.unavailable }
            $0.movieDetailsClient.fetchMovie = { _ in movie }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { $0.finish() }
            }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(MovieDetailsFeature.ViewSnapshot(
                movie: movie,
                recommendedMovies: [],
                castMembers: [],
                crewMembers: []
            ))
        }
    }

}

// MARK: - Test Data

extension MovieDetailsFeatureFetchFeatureFlagsTests {

    static let testMovie = Movie(
        id: 123,
        title: "Test Movie",
        overview: "Test overview",
        isOnWatchlist: false
    )

    static let testRecommendations = [
        MoviePreview(id: 1, title: "Rec 1"),
        MoviePreview(id: 2, title: "Rec 2")
    ]

    static let testCredits = Credits(
        id: 123,
        castMembers: [
            CastMember(id: "cast-1", personID: 456, characterName: "Character", personName: "Actor")
        ],
        crewMembers: [
            CrewMember(id: "crew-1", personID: 789, personName: "Director", job: "Director", department: "Directing")
        ]
    )

}

// MARK: - Test Helpers

private enum FlagError: Error {
    case unavailable
}
