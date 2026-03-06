//
//  TVEpisodeDetailsFeatureFeatureFlagsTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import TVEpisodeDetailsFeature

@MainActor
@Suite("TVEpisodeDetailsFeature updateFeatureFlags Tests")
struct TVEpisodeDetailsFeatureFeatureFlagsTests {

    private typealias Feature = TVEpisodeDetailsFeature

    @Test("updateFeatureFlags enables castAndCrew when client returns true")
    func updateFeatureFlagsEnablesCastAndCrew() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                viewState: .loading
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { true }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = true
        }
    }

    @Test("updateFeatureFlags disables castAndCrew when client returns false")
    func updateFeatureFlagsDisablesCastAndCrew() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                viewState: .loading,
                isCastAndCrewEnabled: true
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { false }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = false
        }
    }

    @Test("updateFeatureFlags defaults to false when client throws")
    func updateFeatureFlagsDefaultsToFalseOnError() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                viewState: .loading,
                isCastAndCrewEnabled: true
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { throw TestError.generic }
        }

        await store.send(.updateFeatureFlags) {
            $0.isCastAndCrewEnabled = false
        }
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
