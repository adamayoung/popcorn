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
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
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

    @Test("fetch populates ViewSnapshot with credits when cast and crew enabled")
    func fetchPopulatesViewSnapshotWithCredits() async {
        let tvSeries = TVSeries.mock

        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(
                tvSeriesID: tvSeries.id,
                isCastAndCrewEnabled: true
            )
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.fetchTVSeries = { _ in tvSeries }
            $0.tvSeriesDetailsClient.fetchCredits = { _ in Credits.mock }
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { true }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.fetch)
        await store.receive(\.loaded) {
            $0.viewState = .ready(
                TVSeriesDetailsFeature.ViewSnapshot(
                    tvSeries: tvSeries,
                    castMembers: Credits.mock.castMembers,
                    crewMembers: Credits.mock.crewMembers
                )
            )
        }

        guard case .ready(let snapshot) = store.state.viewState else {
            Issue.record("Expected viewState to be ready")
            return
        }
        #expect(snapshot.castMembers.count == Credits.mock.castMembers.count)
        #expect(snapshot.crewMembers.count == Credits.mock.crewMembers.count)
    }

    @Test("fetch succeeds with empty credits when credits fetch throws")
    func fetchSucceedsWithEmptyCreditsWhenCreditsFetchThrows() async {
        let tvSeries = TVSeries.mock

        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(
                tvSeriesID: tvSeries.id,
                isCastAndCrewEnabled: true
            )
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.fetchTVSeries = { _ in tvSeries }
            $0.tvSeriesDetailsClient.fetchCredits = { _ in
                throw TestError.creditsFetchFailed
            }
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { true }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.fetch)
        await store.receive(\.loaded) {
            $0.viewState = .ready(TVSeriesDetailsFeature.ViewSnapshot(tvSeries: tvSeries))
        }
    }

    @Test("navigate seasonDetails returns none")
    func navigateSeasonDetailsReturnsNone() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 66732)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.navigate(.seasonDetails(tvSeriesID: 66732, seasonNumber: 1, seasonName: "Season 1")))
    }

    @Test("navigate personDetails returns none")
    func navigatePersonDetailsReturnsNone() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 66732)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.navigate(.personDetails(id: 17419)))
    }

    @Test("navigate castAndCrew returns none")
    func navigateCastAndCrewReturnsNone() async {
        let store = TestStore(
            initialState: TVSeriesDetailsFeature.State(tvSeriesID: 66732)
        ) {
            TVSeriesDetailsFeature()
        } withDependencies: {
            $0.tvSeriesDetailsClient.isCastAndCrewEnabled = { false }
            $0.tvSeriesDetailsClient.isIntelligenceEnabled = { false }
            $0.tvSeriesDetailsClient.isBackdropFocalPointEnabled = { false }
        }

        await store.send(.navigate(.castAndCrew(tvSeriesID: 66732)))
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case creditsFetchFailed
}
