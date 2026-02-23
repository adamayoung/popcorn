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

    @Test("fetch populates ViewSnapshot with episode details")
    func fetchPopulatesViewSnapshotWithEpisodeDetails() async {
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
                episodeName: "Pilot"
            )
        ) {
            TVEpisodeDetailsFeature()
        } withDependencies: {
            $0.tvEpisodeDetailsClient.fetchEpisodeDetails = { _, _, _ in
                episodeDetails
            }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.loaded) {
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
        }

        await store.send(.fetch)
    }

}
