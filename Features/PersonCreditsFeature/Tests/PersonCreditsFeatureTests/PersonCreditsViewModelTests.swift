//
//  PersonCreditsViewModelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PersonCreditsFeature
import Presentation
import Synchronization
import Testing

@Suite("PersonCreditsViewModel")
@MainActor
struct PersonCreditsViewModelTests {

    @Test("load moves to ready with the fetched credits")
    func loadMovesToReadyWithFetchedCredits() async {
        let credits = CreditItem.mocks
        let viewModel = PersonCreditsTestSupport.makeViewModel(
            dependencies: PersonCreditsTestSupport.stubDependencies(credits: credits)
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(PersonCreditsViewSnapshot(credits: credits)))
    }

    @Test("load moves to ready when there are no credits")
    func loadMovesToReadyWhenEmpty() async {
        let viewModel = PersonCreditsTestSupport.makeViewModel(
            dependencies: PersonCreditsTestSupport.stubDependencies(credits: [])
        )

        await viewModel.load()

        #expect(viewModel.viewState == .ready(PersonCreditsViewSnapshot(credits: [])))
    }

    @Test("load passes the person id to the fetch")
    func loadPassesPersonIDToFetch() async {
        let fetchedID = Mutex<Int?>(nil)
        let dependencies = PersonCreditsDependencies(
            fetchCredits: { personID in
                fetchedID.withLock { $0 = personID }
                return []
            }
        )
        let viewModel = PersonCreditsTestSupport.makeViewModel(personID: 42, dependencies: dependencies)

        await viewModel.load()

        #expect(fetchedID.withLock { $0 } == 42)
    }

    @Test("load moves to error when the fetch fails")
    func loadMovesToErrorWhenFetchFails() async {
        let viewModel = PersonCreditsTestSupport.makeViewModel(
            dependencies: PersonCreditsTestSupport.failingDependencies()
        )

        await viewModel.load()

        #expect(viewModel.viewState.isError)
    }

    @Test("load does nothing when already ready")
    func loadDoesNothingWhenAlreadyReady() async {
        let fetchCount = Mutex(0)
        let dependencies = PersonCreditsDependencies(
            fetchCredits: { _ in
                fetchCount.withLock { $0 += 1 }
                return []
            }
        )
        let viewModel = PersonCreditsTestSupport.makeViewModel(
            dependencies: dependencies,
            viewState: .ready(PersonCreditsViewSnapshot(credits: []))
        )

        await viewModel.load()

        #expect(fetchCount.withLock { $0 } == 0)
    }

    @Test("load does nothing when already loading")
    func loadDoesNothingWhenAlreadyLoading() async {
        let fetchCount = Mutex(0)
        let dependencies = PersonCreditsDependencies(
            fetchCredits: { _ in
                fetchCount.withLock { $0 += 1 }
                return []
            }
        )
        let viewModel = PersonCreditsTestSupport.makeViewModel(
            dependencies: dependencies,
            viewState: .loading
        )

        await viewModel.load()

        #expect(fetchCount.withLock { $0 } == 0)
        #expect(viewModel.viewState.isLoading)
    }

    @Test("reload bumps the reload id")
    func reloadBumpsReloadID() {
        let viewModel = PersonCreditsTestSupport.makeViewModel()

        let initialReloadID = viewModel.reloadID
        viewModel.reload()

        #expect(viewModel.reloadID == initialReloadID + 1)
    }

    @Test("selecting a movie credit opens the movie details")
    func selectingMovieCreditOpensMovieDetails() {
        let navigator = SpyPersonCreditsNavigator()
        let viewModel = PersonCreditsTestSupport.makeViewModel(navigator: navigator)

        viewModel.selectCredit(CreditItem.mock(mediaID: 550, mediaType: .movie))

        #expect(navigator.openedMovieID == 550)
        #expect(navigator.openedTVSeriesID == nil)
    }

    @Test("selecting a TV series credit opens the TV series details")
    func selectingTVSeriesCreditOpensTVSeriesDetails() {
        let navigator = SpyPersonCreditsNavigator()
        let viewModel = PersonCreditsTestSupport.makeViewModel(navigator: navigator)

        viewModel.selectCredit(CreditItem.mock(mediaID: 1396, mediaType: .tvSeries))

        #expect(navigator.openedTVSeriesID == 1396)
        #expect(navigator.openedMovieID == nil)
    }

}
