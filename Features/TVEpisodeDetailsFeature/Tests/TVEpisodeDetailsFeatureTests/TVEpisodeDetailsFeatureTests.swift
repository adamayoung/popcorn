//
//  TVEpisodeDetailsFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
@testable import TVEpisodeDetailsFeature

@MainActor
@Suite("TVEpisodeDetailsFeature Tests")
struct TVEpisodeDetailsFeatureTests {

    @Test("didAppear triggers fetch when state is initial")
    func didAppearTriggersFetchWhenInitial() async {
        let episodeDetails = EpisodeDetails(
            name: "Pilot",
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(string: "https://example.com/still.jpg")
        )

        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Episode 1"
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisodeDetails = { _, _, _ in
                episodeDetails
            }
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { false }
        }

        await store.send(.didAppear)
        await store.receive(\.updateFeatureFlags)
        await store.receive(\.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
            $0.episodeName = "Pilot"
            $0.viewState = .ready(
                TVEpisodeDetailsFeature.ViewSnapshot(
                    name: "Pilot",
                    overview: "A chemistry teacher begins cooking meth.",
                    airDate: Date(timeIntervalSince1970: 1_200_528_000),
                    stillURL: URL(string: "https://example.com/still.jpg")
                )
            )
        }
    }

    @Test("didAppear does not trigger fetch when state is loading")
    func didAppearDoesNotTriggerFetchWhenLoading() async {
        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Pilot",
                viewState: .loading
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { false }
        }

        await store.send(.didAppear)
        await store.receive(\.updateFeatureFlags)
    }

    @Test("didAppear does not trigger fetch when state is ready")
    func didAppearDoesNotTriggerFetchWhenReady() async {
        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Pilot",
                viewState: .ready(
                    .init(
                        name: "Pilot",
                        overview: nil,
                        airDate: nil,
                        stillURL: nil
                    )
                )
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { false }
        }

        await store.send(.didAppear)
        await store.receive(\.updateFeatureFlags)
    }

    @Test("fetch handles error")
    func fetchHandlesError() async {
        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Pilot"
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisodeDetails = { _, _, _ in
                throw NSError(domain: "test", code: 1)
            }
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { false }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loadFailed) {
            $0.viewState = .error(
                ViewStateError(NSError(domain: "test", code: 1))
            )
        }
    }

    @Test("fetch with castAndCrew enabled includes credits in snapshot")
    func fetchWithCastAndCrewEnabledIncludesCredits() async {
        let episodeDetails = EpisodeDetails(
            name: "Pilot",
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(string: "https://example.com/still.jpg")
        )
        let credits = Credits.mock

        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Episode 1",
                isCastAndCrewEnabled: true
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisodeDetails = { _, _, _ in
                episodeDetails
            }
            $0.tvEpisodeDetailsClient.fetchCredits = { _, _, _ in
                credits
            }
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { true }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
            $0.episodeName = "Pilot"
            $0.viewState = .ready(
                TVEpisodeDetailsFeature.ViewSnapshot(
                    name: "Pilot",
                    overview: "A chemistry teacher begins cooking meth.",
                    airDate: Date(timeIntervalSince1970: 1_200_528_000),
                    stillURL: URL(string: "https://example.com/still.jpg"),
                    castMembers: credits.castMembers,
                    crewMembers: credits.crewMembers
                )
            )
        }
    }

    @Test("fetch continues when credits fetch fails")
    func fetchContinuesWhenCreditsFetchFails() async {
        let episodeDetails = EpisodeDetails(
            name: "Pilot",
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(string: "https://example.com/still.jpg")
        )

        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Episode 1",
                isCastAndCrewEnabled: true
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisodeDetails = { _, _, _ in
                episodeDetails
            }
            $0.tvEpisodeDetailsClient.fetchCredits = { _, _, _ in
                throw NSError(domain: "test", code: 1)
            }
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { true }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
            $0.episodeName = "Pilot"
            $0.viewState = .ready(
                TVEpisodeDetailsFeature.ViewSnapshot(
                    name: "Pilot",
                    overview: "A chemistry teacher begins cooking meth.",
                    airDate: Date(timeIntervalSince1970: 1_200_528_000),
                    stillURL: URL(string: "https://example.com/still.jpg")
                )
            )
        }
    }

    @Test("navigate action returns none")
    func navigateActionReturnsNone() async {
        let store = TestStore(
            initialState: TVEpisodeDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                episodeName: "Pilot"
            )
        ) {
            TVEpisodeDetailsFeature()
        }

        await store.send(
            .navigate(.castAndCrew(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1))
        )
    }

}
