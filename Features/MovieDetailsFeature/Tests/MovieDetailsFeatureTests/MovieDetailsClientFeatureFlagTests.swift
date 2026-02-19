//
//  MovieDetailsClientFeatureFlagTests.swift
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

@Suite("MovieDetailsClient Feature Flag Tests")
struct MovieDetailsClientFeatureFlagTests {

    // MARK: - isWatchlistEnabled Tests

    @Test("isWatchlistEnabled returns true when feature flag is enabled")
    func isWatchlistEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
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
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
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
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
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
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
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

    // MARK: - isCastAndCrewEnabled Tests

    @Test("isCastAndCrewEnabled returns true when feature flag is enabled")
    func isCastAndCrewEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.movieDetailsCastAndCrew])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isCastAndCrewEnabled()

        #expect(result == true)
    }

    @Test("isCastAndCrewEnabled returns false when feature flag is disabled")
    func isCastAndCrewEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isCastAndCrewEnabled()

        #expect(result == false)
    }

    // MARK: - isBackdropFocalPointEnabled Tests

    @Test("isBackdropFocalPointEnabled returns true when feature flag is enabled")
    func isBackdropFocalPointEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.backdropFocalPoint])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isBackdropFocalPointEnabled()

        #expect(result == true)
    }

    @Test("isBackdropFocalPointEnabled returns false when feature flag is disabled")
    func isBackdropFocalPointEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isBackdropFocalPointEnabled()

        #expect(result == false)
    }

    // MARK: - isRecommendedMoviesEnabled Tests

    @Test("isRecommendedMoviesEnabled returns true when feature flag is enabled")
    func isRecommendedMoviesEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.movieDetailsRecommendedMovies])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isRecommendedMoviesEnabled()

        #expect(result == true)
    }

    @Test("isRecommendedMoviesEnabled returns false when feature flag is disabled")
    func isRecommendedMoviesEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchMovieDetails = MockFetchMovieDetailsUseCase(movieDetails: nil)
            $0.streamMovieDetails = MockStreamMovieDetailsUseCase()
            $0.fetchMovieRecommendations = MockFetchMovieRecommendationsUseCase(movies: [])
            $0.fetchMovieCredits = MockFetchMovieCreditsUseCase(credits: nil)
            $0.toggleWatchlistMovie = MockToggleWatchlistMovieUseCase()
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            MovieDetailsClient.liveValue
        }

        let result = try client.isRecommendedMoviesEnabled()

        #expect(result == false)
    }

}
