//
//  TVSeriesDetailsClientFeatureFlagTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import CoreDomain
import FeatureAccess
import FeatureAccessTestHelpers
import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesDetailsFeature

@Suite("TVSeriesDetailsClient Feature Flag Tests")
struct TVSeriesDetailsClientFeatureFlagTests {

    // MARK: - isCastAndCrewEnabled Tests

    @Test("isCastAndCrewEnabled returns true when feature flag is enabled")
    func isCastAndCrewEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchTVSeriesDetails = MockFetchTVSeriesDetailsUseCase(tvSeriesDetails: nil)
            $0.fetchTVSeriesCredits = MockFetchTVSeriesCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.tvSeriesDetailsCastAndCrew])
        } operation: {
            TVSeriesDetailsClient.liveValue
        }

        let result = try client.isCastAndCrewEnabled()

        #expect(result == true)
    }

    @Test("isCastAndCrewEnabled returns false when feature flag is disabled")
    func isCastAndCrewEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchTVSeriesDetails = MockFetchTVSeriesDetailsUseCase(tvSeriesDetails: nil)
            $0.fetchTVSeriesCredits = MockFetchTVSeriesCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            TVSeriesDetailsClient.liveValue
        }

        let result = try client.isCastAndCrewEnabled()

        #expect(result == false)
    }

    // MARK: - isIntelligenceEnabled Tests

    @Test("isIntelligenceEnabled returns true when feature flag is enabled")
    func isIntelligenceEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchTVSeriesDetails = MockFetchTVSeriesDetailsUseCase(tvSeriesDetails: nil)
            $0.fetchTVSeriesCredits = MockFetchTVSeriesCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.tvSeriesIntelligence])
        } operation: {
            TVSeriesDetailsClient.liveValue
        }

        let result = try client.isIntelligenceEnabled()

        #expect(result == true)
    }

    @Test("isIntelligenceEnabled returns false when feature flag is disabled")
    func isIntelligenceEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchTVSeriesDetails = MockFetchTVSeriesDetailsUseCase(tvSeriesDetails: nil)
            $0.fetchTVSeriesCredits = MockFetchTVSeriesCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            TVSeriesDetailsClient.liveValue
        }

        let result = try client.isIntelligenceEnabled()

        #expect(result == false)
    }

    // MARK: - isBackdropFocalPointEnabled Tests

    @Test("isBackdropFocalPointEnabled returns true when feature flag is enabled")
    func isBackdropFocalPointEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchTVSeriesDetails = MockFetchTVSeriesDetailsUseCase(tvSeriesDetails: nil)
            $0.fetchTVSeriesCredits = MockFetchTVSeriesCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.backdropFocalPoint])
        } operation: {
            TVSeriesDetailsClient.liveValue
        }

        let result = try client.isBackdropFocalPointEnabled()

        #expect(result == true)
    }

    @Test("isBackdropFocalPointEnabled returns false when feature flag is disabled")
    func isBackdropFocalPointEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchTVSeriesDetails = MockFetchTVSeriesDetailsUseCase(tvSeriesDetails: nil)
            $0.fetchTVSeriesCredits = MockFetchTVSeriesCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            TVSeriesDetailsClient.liveValue
        }

        let result = try client.isBackdropFocalPointEnabled()

        #expect(result == false)
    }

}
