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

    // MARK: - Known For

    @Test("load loads the known-for section once the person is ready")
    @MainActor
    func loadLoadsKnownForWhenReady() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchPerson: { _ in Self.testPerson },
                fetchKnownFor: { _ in Self.testKnownForItems }
            )
        )

        await viewModel.load()

        #expect(viewModel.knownForState == .ready(Self.testKnownForItems))
    }

    @Test("load does not load the known-for section when the person fetch fails")
    @MainActor
    func loadSkipsKnownForWhenPersonFails() async {
        let knownForCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchPerson: { _ in throw TestError.generic },
                fetchKnownFor: { _ in knownForCalled.withLock { $0 = true }; return [] }
            )
        )

        await viewModel.load()

        #expect(knownForCalled.withLock { $0 } == false)
        #expect(viewModel.knownForState == .initial)
    }

    @Test("loadKnownFor success moves the known-for state to ready")
    @MainActor
    func loadKnownForSuccess() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchKnownFor: { _ in Self.testKnownForItems })
        )

        await viewModel.loadKnownFor()

        #expect(viewModel.knownForState == .ready(Self.testKnownForItems))
    }

    @Test("loadKnownFor failure sets the known-for state to error, leaving viewState ready")
    @MainActor
    func loadKnownForFailureIsIsolated() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchKnownFor: { _ in throw TestError.generic }),
            viewState: .ready(Self.testViewSnapshot)
        )

        await viewModel.loadKnownFor()

        #expect(viewModel.knownForState == .error(ViewStateError(TestError.generic)))
        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("loadKnownFor is a no-op when already ready")
    @MainActor
    func loadKnownForNoOpWhenReady() async {
        let called = Mutex(false)
        let items = Self.testKnownForItems
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchKnownFor: { _ in called.withLock { $0 = true }; return [] }
            ),
            knownForState: .ready(items)
        )

        await viewModel.loadKnownFor()

        #expect(called.withLock { $0 } == false)
        #expect(viewModel.knownForState == .ready(items))
    }

    @Test("loadKnownFor is a no-op when already loading")
    @MainActor
    func loadKnownForNoOpWhenLoading() async {
        let called = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchKnownFor: { _ in called.withLock { $0 = true }; return [] }
            ),
            knownForState: .loading
        )

        await viewModel.loadKnownFor()

        #expect(called.withLock { $0 } == false)
        #expect(viewModel.knownForState.isLoading)
    }

    @Test("selecting a movie known-for item opens movie details")
    @MainActor
    func selectMovieItemOpensMovieDetails() {
        let navigator = SpyPersonDetailsNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectKnownForItem(
            KnownForItem(id: 99, mediaType: .movie, title: "Movie")
        )

        #expect(navigator.openedMovieID == 99)
        #expect(navigator.openedTVSeriesID == nil)
    }

    @Test("selecting a TV series known-for item opens TV series details")
    @MainActor
    func selectTVSeriesItemOpensTVSeriesDetails() {
        let navigator = SpyPersonDetailsNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectKnownForItem(
            KnownForItem(id: 77, mediaType: .tvSeries, title: "Series")
        )

        #expect(navigator.openedTVSeriesID == 77)
        #expect(navigator.openedMovieID == nil)
    }

}

// MARK: - Spy Navigator

/// Records the movie / TV series a "Known For" tap routes to.
@MainActor
final class SpyPersonDetailsNavigator: PersonDetailsNavigating {
    private(set) var openedMovieID: Int?
    private(set) var openedTVSeriesID: Int?

    func openMovieDetails(id: Int) {
        openedMovieID = id
    }

    func openTVSeriesDetails(id: Int) {
        openedTVSeriesID = id
    }
}

// MARK: - Factories

extension PersonDetailsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: PersonDetailsDependencies = stubDependencies(),
        navigator: any PersonDetailsNavigating = SpyPersonDetailsNavigator(),
        viewState: ViewState<PersonDetailsViewSnapshot> = .initial,
        knownForState: ViewState<[KnownForItem]> = .initial,
        isFocalPointEnabled: Bool = false
    ) -> PersonDetailsViewModel {
        PersonDetailsViewModel(
            personID: 2283,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
            knownForState: knownForState,
            isFocalPointEnabled: isFocalPointEnabled
        )
    }

    static func stubDependencies(
        fetchPerson: @escaping @Sendable (Int) async throws -> Person = { _ in testPerson },
        fetchKnownFor: @escaping @Sendable (Int) async throws -> [KnownForItem] = { _ in [] },
        isFocalPointEnabled: @escaping @Sendable () throws -> Bool = { true }
    ) -> PersonDetailsDependencies {
        PersonDetailsDependencies(
            fetchPerson: fetchPerson,
            fetchKnownFor: fetchKnownFor,
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

    static let testKnownForItems = [
        KnownForItem(id: 1, mediaType: .movie, title: "The Devil Wears Prada"),
        KnownForItem(id: 2, mediaType: .tvSeries, title: "Fortitude")
    ]

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
