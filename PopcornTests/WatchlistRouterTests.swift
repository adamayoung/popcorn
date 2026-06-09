//
//  WatchlistRouterTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import Popcorn
import Testing

@MainActor
@Suite("WatchlistRouter Tests")
struct WatchlistRouterTests {

    // MARK: - WatchlistNavigating (home)

    @Test("home openMovieDetails(id:transitionID:) pushes movieDetails forwarding the transitionID")
    func homeOpenMovieDetailsForwardsTransitionID() {
        let router = WatchlistRouter()
        let navigator = WatchlistRouterNavigator(router: router)

        navigator.openMovieDetails(id: 42, transitionID: "42")

        #expect(router.path == [.movieDetails(id: 42, transitionID: "42")])
        #expect(router.presentedMovieIntelligence == nil)
    }

    // MARK: - MovieDetailsNavigating

    @Test("movie details openMovieDetails(id:) pushes movieDetails with a nil transitionID")
    func movieDetailsOpenMovieDetailsHasNoTransitionID() {
        let router = WatchlistRouter()
        let navigator = WatchlistRouterNavigator(router: router)

        navigator.openMovieDetails(id: 7)

        #expect(router.path == [.movieDetails(id: 7, transitionID: nil)])
    }

    @Test("movie details openPersonDetails(id:) pushes personDetails")
    func movieDetailsOpenPersonDetails() {
        let router = WatchlistRouter()
        let navigator = WatchlistRouterNavigator(router: router)

        navigator.openPersonDetails(id: 99)

        #expect(router.path == [.personDetails(id: 99)])
    }

    @Test("movie details openMovieCastAndCrew(movieID:) pushes movieCastAndCrew")
    func movieDetailsOpenCastAndCrew() {
        let router = WatchlistRouter()
        let navigator = WatchlistRouterNavigator(router: router)

        navigator.openMovieCastAndCrew(movieID: 123)

        #expect(router.path == [.movieCastAndCrew(movieID: 123)])
    }

    @Test("movie details openMovieIntelligence(id:) presents the modal and does not push")
    func movieDetailsOpenIntelligencePresentsModal() {
        let router = WatchlistRouter()
        let navigator = WatchlistRouterNavigator(router: router)

        navigator.openMovieIntelligence(id: 555)

        #expect(router.presentedMovieIntelligence?.movieID == 555)
        #expect(router.path.isEmpty)
    }

    // MARK: - MovieCastAndCrewNavigating

    @Test("cast and crew openPersonDetails(id:transitionID:) pushes personDetails dropping the transitionID")
    func castAndCrewOpenPersonDetailsDropsTransitionID() {
        let router = WatchlistRouter()
        let navigator = WatchlistRouterNavigator(router: router)

        navigator.openPersonDetails(id: 314, transitionID: "314")

        #expect(router.path == [.personDetails(id: 314)])
    }

}
