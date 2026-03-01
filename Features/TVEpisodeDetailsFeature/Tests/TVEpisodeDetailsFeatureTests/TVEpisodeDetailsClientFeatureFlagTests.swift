//
//  TVEpisodeDetailsClientFeatureFlagTests.swift
//  Popcorn
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
@testable import TVEpisodeDetailsFeature
import TVSeriesApplication

@Suite("TVEpisodeDetailsClient Feature Flag Tests")
struct TVEpisodeDetailsClientFeatureFlagTests {

    // MARK: - isCastAndCrewEnabled Tests

    @Test("isCastAndCrewEnabled returns true when feature flag is enabled")
    func isCastAndCrewEnabledReturnsTrue() throws {
        let client = withDependencies {
            $0.fetchTVEpisodeDetails = MockFetchTVEpisodeDetailsUseCase(episodeDetails: nil)
            $0.fetchTVEpisodeCredits = MockFetchTVEpisodeCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [.tvEpisodeDetailsCastAndCrew])
        } operation: {
            TVEpisodeDetailsClient.liveValue
        }

        let result = try client.isCastAndCrewEnabled()

        #expect(result == true)
    }

    @Test("isCastAndCrewEnabled returns false when feature flag is disabled")
    func isCastAndCrewEnabledReturnsFalse() throws {
        let client = withDependencies {
            $0.fetchTVEpisodeDetails = MockFetchTVEpisodeDetailsUseCase(episodeDetails: nil)
            $0.fetchTVEpisodeCredits = MockFetchTVEpisodeCreditsUseCase(credits: nil)
            $0.featureFlags = MockFeatureFlags(enabledFlags: [])
        } operation: {
            TVEpisodeDetailsClient.liveValue
        }

        let result = try client.isCastAndCrewEnabled()

        #expect(result == false)
    }

}
