//
//  MovieDetailsClientTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import CoreDomain
import FeatureAccess
import FeatureAccessTestHelpers
import Foundation
@testable import MovieDetailsFeature
import MoviesApplication
import Testing

@Suite("MovieDetailsClient Tests")
struct MovieDetailsClientTests {

    // MARK: - fetchMovie Tests

    @Test("fetchMovie calls use case and maps result")
    func fetchMovieCallsUseCaseAndMapsResult() async throws {
        let movieID = 798_645
        let movieDetails = MoviesApplication.MovieDetails(
            id: movieID,
            title: "The Running Man",
            tagline: "The race for survival begins.",
            overview: "A thrilling action movie.",
            runtime: 120,
            isOnWatchlist: false
        )

        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: movieDetails)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.watchlist, .movieIntelligence])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try await client.fetchMovie(movieID)

        #expect(result.id == movieID)
        #expect(result.title == "The Running Man")
        #expect(result.tagline == "The race for survival begins.")
        #expect(result.overview == "A thrilling action movie.")
        #expect(result.runtime == 120)
        #expect(result.isOnWatchlist == false)
    }

    // MARK: - fetchRecommendedMovies Tests

    @Test("fetchRecommendedMovies calls use case and maps result")
    func fetchRecommendedMoviesCallsUseCaseAndMapsResult() async throws {
        let movieID = 798_645
        let recommendations = [
            MoviesApplication.MoviePreviewDetails(id: 1, title: "Movie 1", overview: "Overview 1"),
            MoviesApplication.MoviePreviewDetails(id: 2, title: "Movie 2", overview: "Overview 2"),
            MoviesApplication.MoviePreviewDetails(id: 3, title: "Movie 3", overview: "Overview 3")
        ]

        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: recommendations)
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.watchlist, .movieIntelligence])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try await client.fetchRecommendedMovies(movieID)

        #expect(result.count == 3)
        #expect(result[0].id == 1)
        #expect(result[0].title == "Movie 1")
        #expect(result[1].id == 2)
        #expect(result[2].id == 3)
    }

    @Test("fetchRecommendedMovies limits to 5 results")
    func fetchRecommendedMoviesLimitsToFiveResults() async throws {
        let movieID = 798_645
        let recommendations = (1 ... 10).map { index in
            MoviesApplication.MoviePreviewDetails(
                id: index,
                title: "Movie \(index)",
                overview: "Overview \(index)"
            )
        }

        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: recommendations)
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.watchlist, .movieIntelligence])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try await client.fetchRecommendedMovies(movieID)

        #expect(result.count == 5)
        #expect(result[0].id == 1)
        #expect(result[4].id == 5)
    }

    // MARK: - fetchCredits Tests

    @Test("fetchCredits calls use case and maps result")
    func fetchCreditsCallsUseCaseAndMapsResult() async throws {
        let movieID = 798_645
        let creditsDetails = MoviesApplication.CreditsDetails(
            id: movieID,
            cast: [
                MoviesApplication.CastMemberDetails(
                    id: "cast-1",
                    personID: 83271,
                    characterName: "Ben Richards",
                    personName: "Glen Powell",
                    gender: .male,
                    order: 0
                )
            ],
            crew: [
                MoviesApplication.CrewMemberDetails(
                    id: "crew-1",
                    personID: 12345,
                    personName: "Christopher Nolan",
                    job: "Director",
                    gender: .male,
                    department: "Directing"
                )
            ]
        )

        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: creditsDetails)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.watchlist, .movieIntelligence])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try await client.fetchCredits(movieID)

        #expect(result.id == movieID)
        #expect(result.castMembers.count == 1)
        #expect(result.castMembers[0].personName == "Glen Powell")
        #expect(result.crewMembers.count == 1)
        #expect(result.crewMembers[0].personName == "Christopher Nolan")
    }

    // MARK: - toggleOnWatchlist Tests

    @Test("toggleOnWatchlist calls use case")
    func toggleOnWatchlistCallsUseCase() async throws {
        let movieID = 798_645
        let tracker = ToggleTracker()
        let mockToggle = MockToggleWatchlistMovieUseCase { id in
            await tracker.setToggledID(id)
        }

        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = mockToggle
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.watchlist, .movieIntelligence])
        } operation: {
            MovieDetailsClient.liveValue
        }

        try await client.toggleOnWatchlist(movieID)

        let toggledID = await tracker.toggledID
        #expect(toggledID == movieID)
    }

    // MARK: - isWatchlistEnabled Tests

    @Test("isWatchlistEnabled returns true when feature flag is enabled")
    func isWatchlistEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.watchlist])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isWatchlistEnabled()

        #expect(result == true)
    }

    @Test("isWatchlistEnabled returns false when feature flag is disabled")
    func isWatchlistEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isWatchlistEnabled()

        #expect(result == false)
    }

    // MARK: - isIntelligenceEnabled Tests

    @Test("isIntelligenceEnabled returns true when feature flag is enabled")
    func isIntelligenceEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.movieIntelligence])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isIntelligenceEnabled()

        #expect(result == true)
    }

    @Test("isIntelligenceEnabled returns false when feature flag is disabled")
    func isIntelligenceEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isIntelligenceEnabled()

        #expect(result == false)
    }

}
