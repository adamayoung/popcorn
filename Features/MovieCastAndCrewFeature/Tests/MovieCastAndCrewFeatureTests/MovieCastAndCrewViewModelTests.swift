//
//  MovieCastAndCrewViewModelTests.swift
//  MovieCastAndCrewFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import MovieCastAndCrewFeature
import Presentation
import Synchronization
import Testing

@Suite("MovieCastAndCrewViewModel Tests")
struct MovieCastAndCrewViewModelTests {

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
        let navigator = SpyMovieCastAndCrewNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectPerson(id: 456, transitionID: "transition-1")

        #expect(navigator.openedPersonID == 456)
        #expect(navigator.openedPersonTransitionID == "transition-1")
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyMovieCastAndCrewNavigator: MovieCastAndCrewNavigating {
    var openedPersonID: Int?
    var openedPersonTransitionID: String?

    func openPersonDetails(id: Int, transitionID: String?) {
        openedPersonID = id
        openedPersonTransitionID = transitionID
    }
}

// MARK: - Factories

extension MovieCastAndCrewViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: MovieCastAndCrewDependencies = stubDependencies(),
        navigator: any MovieCastAndCrewNavigating = SpyMovieCastAndCrewNavigator(),
        viewState: ViewState<MovieCastAndCrewViewSnapshot> = .initial
    ) -> MovieCastAndCrewViewModel {
        MovieCastAndCrewViewModel(
            movieID: 123,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchCredits: @escaping @Sendable (Int) async throws -> Credits = { _ in testCredits }
    ) -> MovieCastAndCrewDependencies {
        MovieCastAndCrewDependencies(fetchCredits: fetchCredits)
    }

}

// MARK: - Test Data

extension MovieCastAndCrewViewModelTests {

    static let testCredits = Credits(
        id: 123,
        castMembers: [
            CastMember(id: "cast-1", personID: 456, characterName: "Character", personName: "Actor")
        ],
        crewByDepartment: [
            CrewDepartment(
                department: "Directing",
                members: [
                    CrewMember(
                        id: "crew-1",
                        personID: 789,
                        personName: "Director",
                        job: "Director",
                        department: "Directing"
                    )
                ]
            )
        ]
    )

    static var testViewSnapshot: MovieCastAndCrewViewSnapshot {
        MovieCastAndCrewViewSnapshot(
            castMembers: testCredits.castMembers,
            crewByDepartment: testCredits.crewByDepartment
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
