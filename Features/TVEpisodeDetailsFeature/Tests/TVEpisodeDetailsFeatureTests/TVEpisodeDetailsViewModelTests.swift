//
//  TVEpisodeDetailsViewModelTests.swift
//  TVEpisodeDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TVEpisodeDetailsFeature

@Suite("TVEpisodeDetailsViewModel Tests")
struct TVEpisodeDetailsViewModelTests {

    @Test("fetch success loads episode and credits")
    @MainActor
    func fetchSuccessLoadsAllData() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchEpisode: { _, _, _ in Self.testEpisode },
                fetchCredits: { _, _, _ in Self.testCredits },
                isCastAndCrewEnabled: { true }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(fetchEpisode: { _, _, _ in throw TestError.generic })
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("fetch succeeds with empty credits when credits fetch throws")
    @MainActor
    func fetchSucceedsWithEmptyCreditsWhenCreditsFetchThrows() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchEpisode: { _, _, _ in Self.testEpisode },
                fetchCredits: { _, _, _ in throw TestError.generic },
                isCastAndCrewEnabled: { true }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(TVEpisodeDetailsViewSnapshot(episode: Self.testEpisode)))
    }

    @Test("fetch omits credits when cast and crew disabled")
    @MainActor
    func fetchOmitsCreditsWhenCastAndCrewDisabled() async {
        let creditsCalled = Mutex(false)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchEpisode: { _, _, _ in Self.testEpisode },
                fetchCredits: { _, _, _ in creditsCalled.withLock { $0 = true }; return Self.testCredits },
                isCastAndCrewEnabled: { false }
            )
        )

        await viewModel.fetch()

        #expect(creditsCalled.withLock { $0 } == false)
        #expect(viewModel.viewState == .ready(TVEpisodeDetailsViewSnapshot(episode: Self.testEpisode)))
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = Self.testViewSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchEpisode: { _, _, _ in fetchCalled.withLock { $0 = true }; return Self.testEpisode }
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
                fetchEpisode: { _, _, _ in fetchCalled.withLock { $0 = true }; return Self.testEpisode }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("updateFeatureFlags reflects the dependency flag")
    @MainActor
    func updateFeatureFlagsReflectsDependencies() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isCastAndCrewEnabled: { true })
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isCastAndCrewEnabled)
    }

    @Test("updateFeatureFlags defaults to false when the dependency throws")
    @MainActor
    func updateFeatureFlagsDefaultsToFalseOnError() {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(isCastAndCrewEnabled: { throw TestError.generic }),
            isCastAndCrewEnabled: true
        )

        viewModel.updateFeatureFlags()

        #expect(viewModel.isCastAndCrewEnabled == false)
    }

    @Test("navigation methods invoke the navigator with the correct identifiers")
    @MainActor
    func navigationInvokesNavigator() {
        let navigator = SpyTVEpisodeDetailsNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.openCastAndCrew()
        viewModel.selectPerson(id: 789)

        #expect(navigator.openedCastAndCrew?.tvSeriesID == 1396)
        #expect(navigator.openedCastAndCrew?.seasonNumber == 2)
        #expect(navigator.openedCastAndCrew?.episodeNumber == 3)
        #expect(navigator.openedPersonID == 789)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTVEpisodeDetailsNavigator: TVEpisodeDetailsNavigating {
    var openedCastAndCrew: (tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)?
    var openedPersonID: Int?

    func openTVEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        openedCastAndCrew = (tvSeriesID, seasonNumber, episodeNumber)
    }

    func openPersonDetails(id: Int) {
        openedPersonID = id
    }
}

// MARK: - Factories

extension TVEpisodeDetailsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVEpisodeDetailsDependencies = stubDependencies(),
        navigator: any TVEpisodeDetailsNavigating = SpyTVEpisodeDetailsNavigator(),
        viewState: ViewState<TVEpisodeDetailsViewSnapshot> = .initial,
        isCastAndCrewEnabled: Bool = false
    ) -> TVEpisodeDetailsViewModel {
        TVEpisodeDetailsViewModel(
            tvSeriesID: 1396,
            seasonNumber: 2,
            episodeNumber: 3,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState,
            isCastAndCrewEnabled: isCastAndCrewEnabled
        )
    }

    static func stubDependencies(
        fetchEpisode: @escaping @Sendable (Int, Int, Int) async throws -> TVEpisode = { _, _, _ in testEpisode },
        fetchCredits: @escaping @Sendable (Int, Int, Int) async throws -> Credits = { _, _, _ in
            Credits(id: 62085, castMembers: [], crewMembers: [])
        },
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool = { true }
    ) -> TVEpisodeDetailsDependencies {
        TVEpisodeDetailsDependencies(
            fetchEpisode: fetchEpisode,
            fetchCredits: fetchCredits,
            isCastAndCrewEnabled: isCastAndCrewEnabled
        )
    }

}

// MARK: - Test Data

extension TVEpisodeDetailsViewModelTests {

    static let testEpisode = TVEpisode(
        id: 62085,
        name: "Pilot",
        episodeNumber: 1,
        seasonNumber: 1,
        tvSeasonID: 3572,
        tvSeriesID: 1396,
        overview: "A chemistry teacher begins cooking meth.",
        airDate: Date(timeIntervalSince1970: 1_200_528_000),
        stillURL: URL(string: "https://example.com/still.jpg")
    )

    static let testCredits = Credits(
        id: 62085,
        castMembers: [
            CastMember(id: "cast-1", personID: 456, characterName: "Character", personName: "Actor")
        ],
        crewMembers: [
            CrewMember(id: "crew-1", personID: 789, personName: "Director", job: "Director", department: "Directing")
        ]
    )

    static var testViewSnapshot: TVEpisodeDetailsViewSnapshot {
        TVEpisodeDetailsViewSnapshot(
            episode: testEpisode,
            castMembers: testCredits.castMembers,
            crewMembers: testCredits.crewMembers
        )
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
