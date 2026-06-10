//
//  TVSeasonDetailsViewModelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Presentation
import Synchronization
import Testing
@testable import TVSeasonDetailsFeature

@Suite("TVSeasonDetailsViewModel Tests")
struct TVSeasonDetailsViewModelTests {

    @Test("fetch success loads season and episodes")
    @MainActor
    func fetchSuccessLoadsSeasonAndEpisodes() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchSeasonAndEpisodes: { _, _ in (Self.testSeason, Self.testEpisodes) }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("fetch failure sets viewState to error")
    @MainActor
    func fetchFailureSetsError() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchSeasonAndEpisodes: { _, _ in throw TestError.generic }
            )
        )

        await viewModel.fetch()

        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("fetch passes the tv series id and season number to the dependency")
    @MainActor
    func fetchPassesIdentifiers() async {
        let captured = Mutex<(tvSeriesID: Int, seasonNumber: Int)?>(nil)
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchSeasonAndEpisodes: { tvSeriesID, seasonNumber in
                    captured.withLock { $0 = (tvSeriesID, seasonNumber) }
                    return (Self.testSeason, Self.testEpisodes)
                }
            )
        )

        await viewModel.fetch()

        #expect(captured.withLock { $0?.tvSeriesID } == 1396)
        #expect(captured.withLock { $0?.seasonNumber } == 1)
    }

    @Test("fetch is a no-op when already ready")
    @MainActor
    func fetchNoOpWhenReady() async {
        let fetchCalled = Mutex(false)
        let snapshot = Self.testViewSnapshot
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchSeasonAndEpisodes: { _, _ in
                    fetchCalled.withLock { $0 = true }
                    return (Self.testSeason, Self.testEpisodes)
                }
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
                fetchSeasonAndEpisodes: { _, _ in
                    fetchCalled.withLock { $0 = true }
                    return (Self.testSeason, Self.testEpisodes)
                }
            ),
            viewState: .loading
        )

        await viewModel.fetch()

        #expect(fetchCalled.withLock { $0 } == false)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("load delegates to fetch")
    @MainActor
    func loadDelegatesToFetch() async {
        let viewModel = Self.makeViewModel(
            dependencies: Self.stubDependencies(
                fetchSeasonAndEpisodes: { _, _ in (Self.testSeason, Self.testEpisodes) }
            )
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(Self.testViewSnapshot))
    }

    @Test("reload bumps the reload identifier")
    @MainActor
    func reloadBumpsReloadID() {
        let viewModel = Self.makeViewModel()
        let initial = viewModel.reloadID

        viewModel.reload()

        #expect(viewModel.reloadID == initial + 1)
    }

    @Test("selectEpisode invokes the navigator with the correct identifiers")
    @MainActor
    func selectEpisodeInvokesNavigator() {
        let navigator = SpyTVSeasonDetailsNavigator()
        let viewModel = Self.makeViewModel(navigator: navigator)

        viewModel.selectEpisode(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 3)

        #expect(navigator.openedEpisode?.tvSeriesID == 1396)
        #expect(navigator.openedEpisode?.seasonNumber == 1)
        #expect(navigator.openedEpisode?.episodeNumber == 3)
    }

}

// MARK: - Spy Navigator

@MainActor
private final class SpyTVSeasonDetailsNavigator: TVSeasonDetailsNavigating {
    var openedEpisode: (tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)?

    func openEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        openedEpisode = (tvSeriesID, seasonNumber, episodeNumber)
    }
}

// MARK: - Factories

extension TVSeasonDetailsViewModelTests {

    @MainActor
    static func makeViewModel(
        dependencies: TVSeasonDetailsDependencies = stubDependencies(),
        navigator: any TVSeasonDetailsNavigating = SpyTVSeasonDetailsNavigator(),
        viewState: ViewState<TVSeasonDetailsViewSnapshot> = .initial
    ) -> TVSeasonDetailsViewModel {
        TVSeasonDetailsViewModel(
            tvSeriesID: 1396,
            seasonNumber: 1,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(
        fetchSeasonAndEpisodes: @escaping @Sendable (Int, Int) async throws -> (TVSeason, [TVEpisode]) = { _, _ in
            (testSeason, testEpisodes)
        }
    ) -> TVSeasonDetailsDependencies {
        TVSeasonDetailsDependencies(fetchSeasonAndEpisodes: fetchSeasonAndEpisodes)
    }

}

// MARK: - Test Data

extension TVSeasonDetailsViewModelTests {

    static let testSeason = TVSeason(
        id: 3572,
        seasonNumber: 1,
        tvSeriesID: 1396,
        name: "Season 1",
        tvSeriesName: "Breaking Bad",
        posterURL: nil,
        overview: "The first season."
    )

    static let testEpisodes = [
        TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: Date(timeIntervalSince1970: 1_200_528_000),
            stillURL: nil
        )
    ]

    static var testViewSnapshot: TVSeasonDetailsViewSnapshot {
        TVSeasonDetailsViewSnapshot(season: testSeason, episodes: testEpisodes)
    }

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
