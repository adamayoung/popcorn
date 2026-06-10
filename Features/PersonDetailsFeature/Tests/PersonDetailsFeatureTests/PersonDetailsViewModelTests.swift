//
//  PersonDetailsViewModelTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PersonDetailsFeature
import Presentation
import Synchronization
import Testing

@Suite("PersonDetailsViewModel Tests")
struct PersonDetailsViewModelTests {

    @Test("fetch success loads person")
    @MainActor
    func fetchSuccessLoadsPerson() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchPerson: { _ in Self.testPerson })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchPerson: { _ in throw TestError.generic })
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
                fetchPerson: { _ in fetchCalled.withLock { $0 = true }; return Self.testPerson }
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
                fetchPerson: { _ in fetchCalled.withLock { $0 = true }; return Self.testPerson }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("fetch from error state reloads")
    @MainActor
    func fetchFromErrorStateReloads() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchPerson: { _ in Self.testPerson }),
            viewState: .error(ViewStateError(message: "Previous error"))
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("load fetches the person")
    @MainActor
    func loadFetchesPerson() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchPerson: { _ in Self.testPerson })
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("reload bumps reloadID")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()
        let initial = viewModel.reloadID

        viewModel.reload()

        #expect(viewModel.reloadID == initial + 1)
    }

    @Test("updateFeatureFlags enables focalPoint when dependency returns true")
    @MainActor
    func updateFeatureFlagsEnablesFocalPoint() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isFocalPointEnabled: { true })
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isFocalPointEnabled)
    }

    @Test("updateFeatureFlags disables focalPoint when dependency returns false")
    @MainActor
    func updateFeatureFlagsDisablesFocalPoint() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isFocalPointEnabled: { false }),
            isFocalPointEnabled: true
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isFocalPointEnabled == false)
    }

    @Test("updateFeatureFlags defaults to false when the dependency throws")
    @MainActor
    func updateFeatureFlagsDefaultsToFalseOnError() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isFocalPointEnabled: { throw TestError.generic }),
            isFocalPointEnabled: true
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isFocalPointEnabled == false)
    }

    @Test("didAppear updates the feature flags")
    @MainActor
    func didAppearUpdatesFeatureFlags() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isFocalPointEnabled: { true })
        )

        viewModel.didAppear()

        #expect(viewModel.isFocalPointEnabled)
    }

}

// MARK: - Spy Navigator

/// `PersonDetailsNavigating` has no requirements (person details is a leaf screen
/// with no onward navigation), so the spy is a minimal conformance used only to
/// satisfy the view model's `navigator` parameter.
@MainActor
private final class SpyPersonDetailsNavigator: PersonDetailsNavigating {}

// MARK: - Factories

extension PersonDetailsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: PersonDetailsDependencies = stubDependencies(),
        navigator: any PersonDetailsNavigating = SpyPersonDetailsNavigator(),
        viewState: ViewState<PersonDetailsViewSnapshot> = .initial,
        isFocalPointEnabled: Bool = false
    ) -> PersonDetailsViewModel {
        PersonDetailsViewModel(
            personID: 2283,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
            isFocalPointEnabled: isFocalPointEnabled
        )
    }

    static func stubDependencies(
        fetchPerson: @escaping @Sendable (Int) async throws -> Person = { _ in testPerson },
        isFocalPointEnabled: @escaping @Sendable () throws -> Bool = { true }
    ) -> PersonDetailsDependencies {
        PersonDetailsDependencies(
            fetchPerson: fetchPerson,
            isFocalPointEnabled: isFocalPointEnabled
        )
    }

}

// MARK: - Test Data

extension PersonDetailsViewModelTests {

    static let testPerson = Person(
        id: 2283,
        name: "Stanley Tucci",
        biography: "Stanley Tucci Jr. is an American actor.",
        knownForDepartment: "Acting",
        gender: .male,
        profileURL: URL(string: "https://example.com/profile.jpg"),
        initials: "ST"
    )

    static var testViewSnapshot: PersonDetailsViewSnapshot {
        PersonDetailsViewSnapshot(person: testPerson)
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
