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

    private typealias Feature = TVSeasonDetailsFeature

    @Test("fetch populates ViewSnapshot with season and episodes")
    func fetchPopulatesViewSnapshotWithSeasonAndEpisodes() async {
        let season = TVSeason(
            id: 3572,
            seasonNumber: 1,
            tvSeriesID: 1396,
            name: "Season 1",
            tvSeriesName: "Breaking Bad",
            posterURL: nil,
            overview: "The first season."
        )
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

        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvSeasonDetailsClient.fetchSeasonAndEpisodes = { _, _ in
                (season, episodes)
            }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
            $0.viewState = .ready(
                Feature.ViewSnapshot(
                    season: season,
                    episodes: episodes
                )
            )
        }
    }

    @Test("fetch handles error")
    func fetchHandlesError() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1
            )
        ) {
            Feature()
        } withDependencies: {
            $0.tvSeasonDetailsClient.fetchSeasonAndEpisodes = { _, _ in
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
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1,
                viewState: .ready(
                    Feature.ViewSnapshot(
                        season: TVSeason(
                            id: 1,
                            seasonNumber: 1,
                            tvSeriesID: 1,
                            name: "",
                            tvSeriesName: "",
                            posterURL: nil,
                            overview: nil
                        ),
                        episodes: []
                    )
                )
            )
        ) {
            Feature()
        }

        await store.send(.fetch)
    }

    @Test("navigate episodeDetails returns none")
    func navigateEpisodeDetailsReturnsNone() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 1396,
                seasonNumber: 1
            )
        ) {
            Feature()
        }

        await store.send(
            .navigate(.episodeDetails(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1))
        )
    }

}
