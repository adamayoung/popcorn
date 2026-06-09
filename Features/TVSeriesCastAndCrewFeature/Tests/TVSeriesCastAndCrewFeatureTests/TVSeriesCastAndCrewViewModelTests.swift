//
//  TVSeriesCastAndCrewViewModelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TVSeriesCastAndCrewFeature

@Suite("TVSeriesCastAndCrewViewModel Tests")
struct TVSeriesCastAndCrewViewModelTests {

    @Test("fetch success loads cast and crew")
    @MainActor
    func fetchSuccessLoadsCastAndCrew() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchCredits: { _ in Self.testCredits })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchCredits: { _ in throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = Self.testViewSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchCredits: { _ in fetchCalled.withLock { $0 = true }; return Self.testCredits }
            ),
            viewState: .ready(snapshot)
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(snapshot))
    }

    @Test("fetch is a no-op when already loading")
    @MainActor
    func fetchNoOpWhenLoading() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchCredits: { _ in fetchCalled.withLock { $0 = true }; return Self.testCredits }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("load fetches cast and crew")
    @MainActor
    func loadFetchesCastAndCrew() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchCredits: { _ in Self.testCredits })
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("reload bumps reloadID to retry")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()

        #expect(viewModel.reloadID == 0)
        viewModel.reload()
        #expect(viewModel.reloadID == 1)
    }

    @Test("selectPerson invokes the navigator with the correct identifiers")
    @MainActor
    func selectPersonInvokesNavigator() {
        let navigator = SpyTVSeriesCastAndCrewNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectPerson(id: 456, transitionID: "transition-1")

        #expect(navigator.openedPersonID == 456)
        #expect(navigator.openedPersonTransitionID == "transition-1")
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTVSeriesCastAndCrewNavigator: TVSeriesCastAndCrewNavigating {
    var openedPersonID: Int?
    var openedPersonTransitionID: String?

    func openPersonDetails(id: Int, transitionID: String?) {
        openedPersonID = id
        openedPersonTransitionID = transitionID
    }
}

// MARK: - Factories

extension TVSeriesCastAndCrewViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVSeriesCastAndCrewDependencies = stubDependencies(),
        navigator: any TVSeriesCastAndCrewNavigating = SpyTVSeriesCastAndCrewNavigator(),
        viewState: ViewState<TVSeriesCastAndCrewViewSnapshot> = .initial
    ) -> TVSeriesCastAndCrewViewModel {
        TVSeriesCastAndCrewViewModel(
            tvSeriesID: 66732,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchCredits: @escaping @Sendable (Int) async throws -> Credits = { _ in testCredits }
    ) -> TVSeriesCastAndCrewDependencies {
        TVSeriesCastAndCrewDependencies(fetchCredits: fetchCredits)
    }

}

// MARK: - Test Data

extension TVSeriesCastAndCrewViewModelTests {

    static let testCredits = Credits(
        id: 66732,
        castMembers: [
            CastMember(
                id: 456,
                personName: "Actor",
                roles: [CastMember.Role(character: "Character", episodeCount: 10)],
                totalEpisodeCount: 10
            )
        ],
        crewByDepartment: [
            CrewDepartment(
                department: "Directing",
                members: [
                    CrewMember(
                        id: 789,
                        personName: "Director",
                        department: "Directing",
                        jobs: [CrewMember.Job(job: "Director", episodeCount: 10)],
                        totalEpisodeCount: 10
                    )
                ]
            )
        ]
    )

    static var testViewSnapshot: TVSeriesCastAndCrewViewSnapshot {
        TVSeriesCastAndCrewViewSnapshot(
            castMembers: testCredits.castMembers,
            crewByDepartment: testCredits.crewByDepartment
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
