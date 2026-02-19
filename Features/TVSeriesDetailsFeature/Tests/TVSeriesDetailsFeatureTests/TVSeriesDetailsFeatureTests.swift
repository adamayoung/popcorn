//
//  TVSeriesDetailsFeatureTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
@testable import TVSeriesDetailsFeature

@MainActor
@Suite("TVSeriesDetailsFeature Tests")
struct TVSeriesDetailsFeatureTests {

    @Test("fetch populates ViewSnapshot with seasons from client")
    func fetchPopulatesViewSnapshotWithSeasons() async {
        let season = TVSeasonPreview(
            id: 77680,
            seasonNumber: 1,
            name: "Season 1",
            posterURL: URL(string: "https://image.tmdb.org/t/p/w780/poster.jpg")
        )
        let tvSeries = TVSeries.mock
        let tvSeriesWithSeasons = TVSeries(
            id: tvSeries.id,
            name: tvSeries.name,
            overview: tvSeries.overview,
            posterURL: tvSeries.posterURL,
            backdropURL: tvSeries.backdropURL,
            logoURL: tvSeries.logoURL,
            seasons: [season]
        )

        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: tvSeriesWithSeasons.id)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.fetchTVSeries = { _ in tvSeriesWithSeasons }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.fetch)
        await store.receive(\.loaded) {
            $0.viewState = .ready(TVSeriesDetailsFeature.ViewSnapshot(tvSeries: tvSeriesWithSeasons))
        }

        guard case .ready(let snapshot) = store.state.viewState else {
            Issue.record("Expected viewState to be ready")
            return
        }
        #expect(snapshot.tvSeries.seasons.count == 1)
        #expect(snapshot.tvSeries.seasons[0].id == 77680)
        #expect(snapshot.tvSeries.seasons[0].name == "Season 1")
    }

    @Test("navigate seasonDetails returns none")
    func navigateSeasonDetailsReturnsNone() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 66732)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.navigate(.seasonDetails(tvSeriesID: 66732, seasonNumber: 1)))
    }

}
