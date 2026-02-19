//
//  MovieDetailsFeatureFetchTests.swift
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
@Suite("MovieDetailsFeature fetch Tests")
struct MovieDetailsFeatureFetchTests {

    @Test("fetch success loads movie, recommendations, and credits")
    func fetchSuccessLoadsAllData() async {
        let movie = Self.testMovie
        let recommendations = Self.testRecommendations
        let credits = Self.testCredits
        let expectedSnapshot = Self.testViewSnapshot

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { true }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { true }
            $0.movieDetailsClient.fetchMovie = { id in
                #expect(id == 123)
                return movie
            }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { $0.finish() }
            }
            $0.movieDetailsClient.fetchRecommendedMovies = { movieID in
                #expect(movieID == 123)
                return recommendations
            }
            $0.movieDetailsClient.fetchCredits = { movieID in
                #expect(movieID == 123)
                return credits
            }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("fetch failure sends loadFailed with error")
    func fetchFailureSendsLoadFailed() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { true }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { true }
            $0.movieDetailsClient.fetchMovie = { _ in
                throw TestError.generic
            }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { $0.finish() }
            }
            $0.movieDetailsClient.fetchRecommendedMovies = { _ in [] }
            $0.movieDetailsClient.fetchCredits = { _ in
                Credits(id: 123, castMembers: [], crewMembers: [])
            }
        }

        await store.send(.fetch)

        await store.receive(\.loadFailed) {
            $0.viewState = .error(ViewStateError(TestError.generic))
        }
    }

    @Test("fetch starts streaming and updates movie from stream")
    func fetchStartsStreamingAndUpdatesMovie() async {
        let movie = Self.testMovie
        let updatedMovie = Movie(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            isOnWatchlist: true
        )
        let recommendations = Self.testRecommendations
        let credits = Self.testCredits

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        } withDependencies: {
            $0.movieDetailsClient.isCastAndCrewEnabled = { true }
            $0.movieDetailsClient.isRecommendedMoviesEnabled = { true }
            $0.movieDetailsClient.fetchMovie = { _ in movie }
            $0.movieDetailsClient.streamMovie = { _ in
                AsyncThrowingStream { continuation in
                    continuation.yield(updatedMovie)
                    continuation.finish()
                }
            }
            $0.movieDetailsClient.fetchRecommendedMovies = { _ in recommendations }
            $0.movieDetailsClient.fetchCredits = { _ in credits }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(Self.testViewSnapshot)
        }

        await store.receive(\.movieUpdated) {
            $0.viewState = .ready(MovieDetailsFeature.ViewSnapshot(
                movie: updatedMovie,
                recommendedMovies: recommendations,
                castMembers: credits.castMembers,
                crewMembers: credits.crewMembers
            ))
        }
    }

    @Test("movieUpdated updates movie in ready state")
    func movieUpdatedUpdatesMovieInReadyState() async {
        let snapshot = Self.testViewSnapshot
        let updatedMovie = Movie(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            isOnWatchlist: true
        )

        let store = TestStore(
            initialState: MovieDetailsFeature.State(
                movieID: 123,
                viewState: .ready(snapshot)
            )
        ) {
            MovieDetailsFeature()
        }

        await store.send(.movieUpdated(updatedMovie)) {
            $0.viewState = .ready(MovieDetailsFeature.ViewSnapshot(
                movie: updatedMovie,
                recommendedMovies: Self.testRecommendations,
                castMembers: Self.testCredits.castMembers,
                crewMembers: Self.testCredits.crewMembers
            ))
        }
    }

    @Test("movieUpdated when not ready does nothing")
    func movieUpdatedWhenNotReadyDoesNothing() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.movieUpdated(Self.testMovie))
    }

    @Test("loaded sets viewState to ready")
    func loadedSetsViewStateToReady() async {
        let snapshot = MovieDetailsFeature.ViewSnapshot(
            movie: Movie(
                id: 123,
                title: "Test Movie",
                overview: "Overview",
                isOnWatchlist: false
            ),
            recommendedMovies: [],
            castMembers: [],
            crewMembers: []
        )

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.loaded(snapshot)) {
            $0.viewState = .ready(snapshot)
        }
    }

    @Test("loadFailed sets viewState to error")
    func loadFailedSetsViewStateToError() async {
        let error = ViewStateError(message: "Failed to load movie")

        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.loadFailed(error)) {
            $0.viewState = .error(error)
        }
    }

}

// MARK: - Test Data

extension MovieDetailsFeatureFetchTests {

    static let testMovie = Movie(
        id: 123,
        title: "Test Movie",
        tagline: "A test tagline",
        overview: "Test overview",
        runtime: 120,
        genres: [
            Genre(id: 28, name: "Action"),
            Genre(id: 53, name: "Thriller")
        ],
        budget: 50_000_000,
        revenue: 150_000_000,
        homepageURL: URL(string: "https://example.com/movie"),
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

    static var testViewSnapshot: MovieDetailsFeature.ViewSnapshot {
        MovieDetailsFeature.ViewSnapshot(
            movie: testMovie,
            recommendedMovies: testRecommendations,
            castMembers: testCredits.castMembers,
            crewMembers: testCredits.crewMembers
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
