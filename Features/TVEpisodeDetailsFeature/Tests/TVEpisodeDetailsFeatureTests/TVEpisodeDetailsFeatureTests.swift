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

    private typealias Feature = TVEpisodeDetailsFeature

    @Test("didAppear triggers fetch when state is initial")
    func didAppearTriggersFetchWhenInitial() async {
        let episode = TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            tvSeasonID: 3572,
            tvSeriesID: 1396,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(string: "https://example.com/still.jpg")
        )

        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisode = { _, _, _ in
                episode
            }
            $0.tvEpisodeDetailsClient.isCastAndCrewEnabled = { false }
        }

        await store.send(.didAppear)
        await store.receive(\.updateFeatureFlags)
        await store.receive(\.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
            $0.viewState = .ready(
                Feature.ViewSnapshot(episode: episode)
            )
        }
    }

    @Test("didAppear does not trigger fetch when state is loading")
    func didAppearDoesNotTriggerFetchWhenLoading() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                viewState: .loading
            )
        ) {
            Feature()
        }

        await store.send(.didAppear)
    }

    @Test("didAppear does not trigger fetch when state is ready")
    func didAppearDoesNotTriggerFetchWhenReady() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                viewState: .ready(
                    Feature.ViewSnapshot(episode: TVEpisode.mock)
                )
            )
        ) {
            Feature()
        }

        await store.send(.didAppear)
    }

    @Test("fetch handles error")
    func fetchHandlesError() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisode = { _, _, _ in
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
        let episode = TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            tvSeasonID: 3572,
            tvSeriesID: 1396,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(string: "https://example.com/still.jpg")
        )
        let credits = Credits.mock

        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                isCastAndCrewEnabled: true
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisode = { _, _, _ in
                episode
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
            $0.viewState = .ready(
                Feature.ViewSnapshot(
                    episode: episode,
                    castMembers: credits.castMembers,
                    crewMembers: credits.crewMembers
                )
            )
        }
    }

    @Test("fetch continues when credits fetch fails")
    func fetchContinuesWhenCreditsFetchFails() async {
        let episode = TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            tvSeasonID: 3572,
            tvSeriesID: 1396,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: URL(string: "https://example.com/still.jpg")
        )

        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
                isCastAndCrewEnabled: true
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisode = { _, _, _ in
                episode
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
            $0.viewState = .ready(
                Feature.ViewSnapshot(episode: episode)
            )
        }
    }

    @Test("navigate to cast and crew uses tvSeriesID from state")
    func navigateToCastAndCrewUsesTVSeriesIDFromState() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 2,
                episodeNumber: 3
            )
        ) {
            Feature()
        }

        await store.send(
            .navigate(.castAndCrew(tvSeriesID: 1396, seasonNumber: 2, episodeNumber: 3))
        )
    }

    @Test("navigate to person details returns none")
    func navigateToPersonDetailsReturnsNone() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1
            )
        ) {
            Feature()
        }

        await store.send(.navigate(.personDetails(id: 500)))
    }

}
