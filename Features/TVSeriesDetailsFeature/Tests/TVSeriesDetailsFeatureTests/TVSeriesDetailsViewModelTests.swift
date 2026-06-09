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

    @Test("fetch success loads tv series and credits")
    @MainActor
    func fetchSuccessLoadsAllData() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in Self.testTVSeries },
                fetchCredits: { _ in Self.testCredits }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchTVSeries: { _ in throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("fetch succeeds with empty credits when credits fetch throws")
    @MainActor
    func fetchSucceedsWithEmptyCreditsWhenCreditsFetchThrows() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in Self.testTVSeries },
                fetchCredits: { _ in throw TestError.generic },
                isCastAndCrewEnabled: { true }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(TVSeriesDetailsViewSnapshot(tvSeries: Self.testTVSeries)))
    }

    @Test("fetch omits credits when cast and crew disabled")
    @MainActor
    func fetchOmitsCreditsWhenCastAndCrewDisabled() async {
        let creditsCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in Self.testTVSeries },
                fetchCredits: { _ in creditsCalled.withLock { $0 = true }; return Self.testCredits },
                isCastAndCrewEnabled: { false }
            )
        )

        await viewModel.fetch()

        #expect(creditsCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(TVSeriesDetailsViewSnapshot(tvSeries: Self.testTVSeries)))
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = Self.testViewSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchTVSeries: { _ in fetchCalled.withLock { $0 = true }; return Self.testTVSeries }
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
        viewState: ViewState<TVSeriesDetailsViewSnapshot> = .initial,
        isCastAndCrewEnabled: Bool = false,
        isIntelligenceEnabled: Bool = false,
        isBackdropFocalPointEnabled: Bool = false
    ) -> TVSeriesDetailsViewModel {
        TVSeriesDetailsViewModel(
            tvSeriesID: 123,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
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

    static var testViewSnapshot: TVSeriesDetailsViewSnapshot {
        TVSeriesDetailsViewSnapshot(
            tvSeries: testTVSeries,
            castMembers: testCredits.castMembers,
            crewMembers: testCredits.crewMembers
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
