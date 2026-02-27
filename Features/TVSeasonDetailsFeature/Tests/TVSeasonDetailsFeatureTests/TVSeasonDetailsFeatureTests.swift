//
//  TVSeasonDetailsFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
@testable import TVSeasonDetailsFeature

@MainActor
@Suite("TVSeasonDetailsFeature Tests")
struct TVSeasonDetailsFeatureTests {

    @Test("fetch populates ViewSnapshot with episodes")
    func fetchPopulatesViewSnapshotWithEpisodes() async {
        let episodes = [
            TVEpisode(
                id: 62085,
                name: "Pilot",
                episodeNumber: 1,
                overview: "A chemistry teacher begins cooking meth.",
                airDate: Date(timeIntervalSince1970: 1_200_528_000),
                stillURL: nil
            )
        ]
        let seasonDetails = SeasonDetails(
            overview: "The first season.",
            episodes: episodes
        )

        let store = TestStore(
            initialState: TVSeasonDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                seasonName: "Season 1"
            )
        ) {
            TVSeasonDetailsFeature()
        } withDependencies: {
            $0.tvSeasonDetailsClient.fetchSeasonDetails = { _, _ in
                seasonDetails
            }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
            $0.viewState = .ready(
                TVSeasonDetailsFeature.ViewSnapshot(
                    overview: "The first season.",
                    episodes: episodes
                )
            )
        }
    }

    @Test("fetch handles error")
    func fetchHandlesError() async {
        let store = TestStore(
            initialState: TVSeasonDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                seasonName: "Season 1"
            )
        ) {
            TVSeasonDetailsFeature()
        } withDependencies: {
            $0.tvSeasonDetailsClient.fetchSeasonDetails = { _, _ in
                throw NSError(domain: "test", code: 1)
            }
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

    @Test("fetch does not reload when ready")
    func fetchDoesNotReloadWhenReady() async {
        let store = TestStore(
            initialState: TVSeasonDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                seasonName: "Season 1",
                viewState: .ready(
                    .init(overview: nil, episodes: [])
                )
            )
        ) {
            TVSeasonDetailsFeature()
        }

        await store.send(.fetch)
    }

    @Test("navigate episodeDetails returns none")
    func navigateEpisodeDetailsReturnsNone() async {
        let store = TestStore(
            initialState: TVSeasonDetailsFeature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                seasonName: "Season 1"
            )
        ) {
            TVSeasonDetailsFeature()
        }

        await store.send(
            .navigate(.episodeDetails(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1, episodeName: "Pilot"))
        )
    }

}
