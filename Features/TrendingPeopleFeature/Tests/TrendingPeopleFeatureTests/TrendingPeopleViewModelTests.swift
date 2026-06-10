//
//  TrendingPeopleViewModelTests.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Synchronization
import Testing
@testable import TrendingPeopleFeature

@Suite("TrendingPeopleViewModel Tests")
struct TrendingPeopleViewModelTests {

    @Test("load fetches and populates people")
    @MainActor
    func loadPopulatesPeople() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingPeople: {
                    fetchCalled.withLock { $0 = true }
                    return Self.testPeople
                }
            )
        )

        await viewModel.load()

        #expect(fetchCalled.withLock { $0 } == true)
        #expect(viewModel.people == Self.testPeople)
    }

    @Test("load failure leaves people unchanged")
    @MainActor
    func loadFailureLeavesPeopleUnchanged() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingPeople: { throw TestError.generic }
            )
        )

        await viewModel.load()

        #expect(viewModel.people.isEmpty)
    }

    @Test("load replaces existing people on success")
    @MainActor
    func loadReplacesExistingPeople() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTrendingPeople: { Self.testPeople }
            ),
            people: [PersonPreview(id: 999, name: "Stale Person")]
        )

        await viewModel.load()

        #expect(viewModel.people == Self.testPeople)
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()

        viewModel.reload()

        #expect(viewModel.reloadID == 1)
    }

    @Test("selectPerson invokes the navigator with the correct identifier")
    @MainActor
    func selectPersonInvokesNavigator() {
        let navigator = SpyTrendingPeopleNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectPerson(id: 456)

        #expect(navigator.openedPersonID == 456)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTrendingPeopleNavigator: TrendingPeopleNavigating {
    var openedPersonID: Int?

    func openPersonDetails(id: Int) {
        openedPersonID = id
    }
}

// MARK: - Factories

extension TrendingPeopleViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TrendingPeopleDependencies = stubDependencies(),
        navigator: any TrendingPeopleNavigating = SpyTrendingPeopleNavigator(),
        people: [PersonPreview] = []
    ) -> TrendingPeopleViewModel {
        TrendingPeopleViewModel(
            dependencies: dependencies,
            navigator: navigator,
            people: people
        )
    }

    static func stubDependencies(
        fetchTrendingPeople: @escaping @Sendable () async throws -> [PersonPreview] = { [] }
    ) -> TrendingPeopleDependencies {
        TrendingPeopleDependencies(
            fetchTrendingPeople: fetchTrendingPeople
        )
    }

}

// MARK: - Test Data

extension TrendingPeopleViewModelTests {

    static let testPeople = [
        PersonPreview(id: 1, name: "Person One"),
        PersonPreview(id: 2, name: "Person Two")
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
