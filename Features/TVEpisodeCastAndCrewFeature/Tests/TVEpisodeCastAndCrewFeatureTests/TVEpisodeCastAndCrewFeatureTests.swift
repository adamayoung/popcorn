//
//  TVEpisodeCastAndCrewFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TCAFoundation
import Testing
@testable import TVEpisodeCastAndCrewFeature

private typealias Feature = TVEpisodeCastAndCrewFeature

@MainActor
@Suite("TVEpisodeCastAndCrewFeature")
struct TVEpisodeCastAndCrewFeatureTests {

    @Test("Initial state is initial")
    func initialStateIsInitial() {
        let state = Feature.State(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)

        #expect(state.viewState == .initial)
        #expect(state.viewState.isLoading == false)
    }

    @Test("Fetch success transitions to ready with view snapshot")
    func fetchSuccessTransitionsToReady() async {
        let credits = Credits.mock

        let store = TestStore(
            initialState: Feature.State(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeCastAndCrewClient.fetchCredits = { _, _, _ in credits }
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
            initialState: Feature.State(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
        ) {
            Feature()
        } withDependencies: {
            $0.tvEpisodeCastAndCrewClient.fetchCredits = { _, _, _ in
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
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
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
                tvSeriesID: 1396,
                seasonNumber: 1,
                episodeNumber: 1,
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
            initialState: Feature.State(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
        ) {
            Feature()
        }

        await store.send(Feature.Action.navigate(.personDetails(id: 123, transitionID: nil)))
    }

    @Test("ViewSnapshot groups crew members by department")
    func viewSnapshotGroupsCrewByDepartment() {
        let crewMembers: [CrewMember] = [
            CrewMember(
                id: "crew-1",
                personID: 1,
                personName: "Matt Duffer",
                job: "Director",
                department: "Directing",
                initials: "MD"
            ),
            CrewMember(
                id: "crew-2",
                personID: 2,
                personName: "Ross Duffer",
                job: "Writer",
                department: "Writing",
                initials: "RD"
            ),
            CrewMember(
                id: "crew-3",
                personID: 3,
                personName: "Shawn Levy",
                job: "Director",
                department: "Directing",
                initials: "SL"
            )
        ]

        let snapshot = Feature.ViewSnapshot(castMembers: [], crewMembers: crewMembers)

        #expect(snapshot.crewByDepartment.count == 2)
        #expect(snapshot.crewByDepartment["Directing"]?.count == 2)
        #expect(snapshot.crewByDepartment["Writing"]?.count == 1)
    }

}
