//
//  TVSeriesDetailsViewModelTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TVSeriesDetailsFeature

@Suite("TVSeriesDetailsViewModel Tests")
struct TVSeriesDetailsViewModelTests {

    // MARK: - Primary fetch

    @Test("fetch success sets viewState to the series without touching the section")
    @MainActor
    func fetchSuccessSetsSeries() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchTVSeries: { _ in Self.testTVSeries })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testTVSeries))
        #expect(viewModel.castAndCrewState.isInitial)
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchTVSeries: { _ in throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
        #expect(viewModel.castAndCrewState.isInitial)
    }

    // MARK: - Progressive load

    @Test("load populates the cast-and-crew section after the series is ready")
    @MainActor
    func loadPopulatesSection() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in Self.testTVSeries },
                fetchCredits: { _ in Self.testCredits }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.testTVSeries))
        #expect(viewModel.castAndCrewState == .ready(Self.testCredits))
    }

    @Test("load short-circuits the section when the primary fetch fails")
    @MainActor
    func loadShortCircuitsSectionOnPrimaryFailure() async {
        let creditsCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in throw TestError.generic },
                fetchCredits: { _ in creditsCalled.withLock { $0 = true }; return Self.testCredits }
            )
        )

        await viewModel.load()

        #expect(creditsCalled.withLock { $0 } == false)
        #expect(viewModel.castAndCrewState.isInitial)
    }

    @Test("a credits failure degrades the section without failing the screen")
    @MainActor
    func creditsFailureDegradesOnly() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in Self.testTVSeries },
                fetchCredits: { _ in throw TestError.generic }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.testTVSeries))
        #expect(viewModel.castAndCrewState.isError)
    }

    // MARK: - Feature flags

    @Test("a disabled cast-and-crew flag leaves the section initial and skips its dependency")
    @MainActor
    func disabledFlagSkipsDependency() async {
        let creditsCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in Self.testTVSeries },
                fetchCredits: { _ in creditsCalled.withLock { $0 = true }; return Self.testCredits },
                isCastAndCrewEnabled: { false }
            )
        )

        await viewModel.load()

        #expect(creditsCalled.withLock { $0 } == false)
        #expect(viewModel.castAndCrewState.isInitial)
    }

    @Test("a flag turning off resets a previously ready section to initial")
    @MainActor
    func flagTurningOffResetsSection() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isCastAndCrewEnabled: { false }),
            castAndCrewState: .ready(Self.testCredits)
        )

        await viewModel.loadCastAndCrew()

        #expect(viewModel.castAndCrewState.isInitial)
    }

    // MARK: - Re-entry guards

    @Test("a cancelled section load resets to initial and reloads on the next run")
    @MainActor
    func cancelledSectionReloadsOnNextRun() async {
        let callCount = Mutex(0)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchCredits: { _ in
                    let attempt = callCount.withLock { $0 += 1; return $0 }
                    if attempt == 1 {
                        throw CancellationError()
                    }
                    return Self.testCredits
                }
            )
        )

        await viewModel.loadCastAndCrew()
        #expect(viewModel.castAndCrewState.isInitial)

        await viewModel.loadCastAndCrew()
        #expect(viewModel.castAndCrewState == .ready(Self.testCredits))
    }

    @Test("a section load is a no-op when the section is already ready")
    @MainActor
    func sectionLoadNoOpWhenReady() async {
        let called = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchCredits: { _ in called.withLock { $0 = true }; return Self.testCredits }
            ),
            castAndCrewState: .ready(Self.testCredits)
        )

        await viewModel.loadCastAndCrew()

        #expect(called.withLock { $0 } == false)
        #expect(viewModel.castAndCrewState == .ready(Self.testCredits))
    }

    @Test("a section load is a no-op when the section is already loading")
    @MainActor
    func sectionLoadNoOpWhenLoading() async {
        let called = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchCredits: { _ in called.withLock { $0 = true }; return Self.testCredits }
            ),
            castAndCrewState: .loading
        )

        await viewModel.loadCastAndCrew()

        #expect(called.withLock { $0 } == false)
        #expect(viewModel.castAndCrewState.isLoading)
    }

    // MARK: - Guards

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in fetchCalled.withLock { $0 = true }; return Self.testTVSeries }
            ),
            viewState: .ready(Self.testTVSeries)
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(Self.testTVSeries))
    }

    @Test("fetch is a no-op when already loading")
    @MainActor
    func fetchNoOpWhenLoading() async {
        let fetchCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in fetchCalled.withLock { $0 = true }; return Self.testTVSeries }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("updateFeatureFlags reflects the dependency flags")
    @MainActor
    func updateFeatureFlagsReflectsDependencies() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                isCastAndCrewEnabled: { true },
                isIntelligenceEnabled: { true },
                isBackdropFocalPointEnabled: { true }
            )
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isCastAndCrewEnabled)
        #expect(viewModel.isIntelligenceEnabled)
        #expect(viewModel.isBackdropFocalPointEnabled)
    }

    @Test("updateFeatureFlags defaults to false when the dependency throws")
    @MainActor
    func updateFeatureFlagsDefaultsToFalseOnError() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                isCastAndCrewEnabled: { throw TestError.generic },
                isIntelligenceEnabled: { throw TestError.generic },
                isBackdropFocalPointEnabled: { throw TestError.generic }
            ),
            isCastAndCrewEnabled: true,
            isIntelligenceEnabled: true,
            isBackdropFocalPointEnabled: true
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isCastAndCrewEnabled == false)
        #expect(viewModel.isIntelligenceEnabled == false)
        #expect(viewModel.isBackdropFocalPointEnabled == false)
    }

    @Test("navigation methods invoke the navigator with the correct identifiers")
    @MainActor
    func navigationInvokesNavigator() {
        let navigator = SpyTVSeriesDetailsNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.openIntelligence(id: 321)
        viewModel.selectSeason(seasonNumber: 2)
        viewModel.selectPerson(id: 789)
        viewModel.openCastAndCrew()

        #expect(navigator.openedIntelligenceID == 321)
        #expect(navigator.openedSeason?.tvSeriesID == 123)
        #expect(navigator.openedSeason?.seasonNumber == 2)
        #expect(navigator.openedPersonID == 789)
        #expect(navigator.openedCastAndCrewTVSeriesID == 123)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTVSeriesDetailsNavigator: TVSeriesDetailsNavigating {
    var openedIntelligenceID: Int?
    var openedSeason: (tvSeriesID: Int, seasonNumber: Int)?
    var openedPersonID: Int?
    var openedCastAndCrewTVSeriesID: Int?

    func openTVSeriesIntelligence(id: Int) {
        openedIntelligenceID = id
    }

    func openSeasonDetails(tvSeriesID: Int, seasonNumber: Int) {
        openedSeason = (tvSeriesID, seasonNumber)
    }

    func openPersonDetails(id: Int) {
        openedPersonID = id
    }

    func openTVSeriesCastAndCrew(tvSeriesID: Int) {
        openedCastAndCrewTVSeriesID = tvSeriesID
    }
}

// MARK: - Factories

extension TVSeriesDetailsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVSeriesDetailsDependencies = stubDependencies(),
        navigator: any TVSeriesDetailsNavigating = SpyTVSeriesDetailsNavigator(),
        viewState: ViewState<TVSeries> = .initial,
        castAndCrewState: ViewState<Credits> = .initial,
        isCastAndCrewEnabled: Bool = false,
        isIntelligenceEnabled: Bool = false,
        isBackdropFocalPointEnabled: Bool = false
    ) -> TVSeriesDetailsViewModel {
        TVSeriesDetailsViewModel(
            tvSeriesID: 123,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
            castAndCrewState: castAndCrewState,
            isCastAndCrewEnabled: isCastAndCrewEnabled,
            isIntelligenceEnabled: isIntelligenceEnabled,
            isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
        )
    }

    static func stubDependencies(
        fetchTVSeries: @escaping @Sendable (Int) async throws -> TVSeries = { _ in testTVSeries },
        fetchCredits: @escaping @Sendable (Int) async throws -> Credits = { _ in
            Credits(id: 123, castMembers: [], crewMembers: [])
        },
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool = { true },
        isIntelligenceEnabled: @escaping @Sendable () throws -> Bool = { true },
        isBackdropFocalPointEnabled: @escaping @Sendable () throws -> Bool = { true }
    ) -> TVSeriesDetailsDependencies {
        TVSeriesDetailsDependencies(
            fetchTVSeries: fetchTVSeries,
            fetchCredits: fetchCredits,
            isCastAndCrewEnabled: isCastAndCrewEnabled,
            isIntelligenceEnabled: isIntelligenceEnabled,
            isBackdropFocalPointEnabled: isBackdropFocalPointEnabled
        )
    }

}

// MARK: - Test Data

extension TVSeriesDetailsViewModelTests {

    static let testTVSeries = TVSeries(
        id: 123,
        name: "Test Series",
        genres: [Genre(id: 18, name: "Drama")],
        overview: "Test overview",
        seasons: [
            TVSeasonPreview(id: 77680, seasonNumber: 1, name: "Season 1")
        ]
    )

    static let testCredits = Credits(
        id: 123,
        castMembers: [
            CastMember(id: "cast-1", personID: 456, characterName: "Character", personName: "Actor")
        ],
        crewMembers: [
            CrewMember(id: "crew-1", personID: 789, personName: "Director", job: "Director", department: "Directing")
        ]
    )

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
