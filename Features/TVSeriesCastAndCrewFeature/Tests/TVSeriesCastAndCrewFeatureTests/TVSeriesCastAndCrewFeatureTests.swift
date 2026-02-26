//
//  TVSeriesCastAndCrewFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
import TVSeriesApplication
@testable import TVSeriesCastAndCrewFeature

private typealias Feature = TVSeriesCastAndCrewFeature

@MainActor
@Suite("TVSeriesCastAndCrewFeature")
struct TVSeriesCastAndCrewFeatureTests {

    @Test("Initial state is initial")
    func initialStateIsInitial() {
        let state = Feature.State(tvSeriesID: 66732)

        #expect(state.viewState == .initial)
        #expect(state.viewState.isLoading == false)
    }

    @Test("Fetch success transitions to ready with view snapshot")
    func fetchSuccessTransitionsToReady() async {
        let credits = Credits.mock

        let store = TestStore(
            initialState: Feature.State(tvSeriesID: 66732)
        ) {
            Feature()
        } withDependencies: {
            $0.tvSeriesCastAndCrewClient.fetchCredits = { _ in credits }
        }

        let expectedSnapshot = Feature.ViewSnapshot(
            castMembers: credits.castMembers,
            crewMembers: credits.crewMembers
        )

        await store.send(.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("Fetch failure transitions to error")
    func fetchFailureTransitionsToError() async {
        let testError = NSError(domain: "test", code: 1)

        let store = TestStore(
            initialState: Feature.State(tvSeriesID: 66732)
        ) {
            Feature()
        } withDependencies: {
            $0.tvSeriesCastAndCrewClient.fetchCredits = { _ in
                throw testError
            }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.loadFailed) {
            $0.viewState = ViewState<Feature.ViewSnapshot>.error(
                ViewStateError(testError)
            )
        }
    }

    @Test("Fetch when already ready returns none")
    func fetchWhenReadyReturnsNone() async {
        let snapshot = Feature.ViewSnapshot(
            castMembers: [],
            crewMembers: []
        )

        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 66732,
                viewState: .ready(snapshot)
            )
        ) {
            Feature()
        }

        await store.send(.fetch)
    }

    @Test("Fetch when loading returns none")
    func fetchWhenLoadingReturnsNone() async {
        let store = TestStore(
            initialState: Feature.State(
                tvSeriesID: 66732,
                viewState: .loading
            )
        ) {
            Feature()
        }

        await store.send(.fetch)
    }

    @Test("Navigate action returns none")
    func navigateActionReturnsNone() async {
        let store = TestStore(
            initialState: Feature.State(tvSeriesID: 66732)
        ) {
            Feature()
        }

        await store.send(Feature.Action.navigate(.personDetails(id: 123, transitionID: nil)))
    }

}
