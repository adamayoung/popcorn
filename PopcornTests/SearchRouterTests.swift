//
//  SearchRouterTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import Popcorn
import Testing

@MainActor
@Suite("SearchRouter Tests")
struct SearchRouterTests {

    // MARK: - MediaSearchNavigating (home)

    @Test("home openMovieDetails(id:) pushes movieDetails with a nil transitionID")
    func homeOpenMovieDetails() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openMovieDetails(id: 42)

        #expect(router.path == [.movieDetails(id: 42, transitionID: nil)])
        #expect(router.presentedMovieIntelligence == nil)
        #expect(router.presentedTVSeriesIntelligence == nil)
    }

    @Test("home openTVSeriesDetails(id:) pushes tvSeriesDetails")
    func homeOpenTVSeriesDetails() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openTVSeriesDetails(id: 7)

        #expect(router.path == [.tvSeriesDetails(id: 7)])
    }

    @Test("home openPersonDetails(id:) pushes personDetails")
    func homeOpenPersonDetails() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openPersonDetails(id: 99)

        #expect(router.path == [.personDetails(id: 99)])
    }

    // MARK: - MovieDetailsNavigating

    @Test("movie details openMovieCastAndCrew(movieID:) pushes movieCastAndCrew")
    func movieDetailsOpenCastAndCrew() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openMovieCastAndCrew(movieID: 123)

        #expect(router.path == [.movieCastAndCrew(movieID: 123)])
    }

    @Test("movie details openMovieIntelligence(id:) presents the modal and does not push")
    func movieDetailsOpenIntelligencePresentsModal() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openMovieIntelligence(id: 555)

        #expect(router.presentedMovieIntelligence?.movieID == 555)
        #expect(router.path.isEmpty)
    }

    // MARK: - TVSeriesDetailsNavigating

    @Test("tv series details openSeasonDetails(tvSeriesID:seasonNumber:) pushes tvSeasonDetails")
    func tvSeriesDetailsOpenSeasonDetails() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openSeasonDetails(tvSeriesID: 10, seasonNumber: 2)

        #expect(router.path == [.tvSeasonDetails(tvSeriesID: 10, seasonNumber: 2)])
    }

    @Test("tv series details openTVSeriesCastAndCrew(tvSeriesID:) pushes tvSeriesCastAndCrew")
    func tvSeriesDetailsOpenCastAndCrew() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openTVSeriesCastAndCrew(tvSeriesID: 88)

        #expect(router.path == [.tvSeriesCastAndCrew(tvSeriesID: 88)])
    }

    @Test("tv series details openTVSeriesIntelligence(id:) presents the modal and does not push")
    func tvSeriesDetailsOpenIntelligencePresentsModal() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openTVSeriesIntelligence(id: 777)

        #expect(router.presentedTVSeriesIntelligence?.tvSeriesID == 777)
        #expect(router.path.isEmpty)
    }

    // MARK: - TVSeasonDetailsNavigating

    @Test("tv season details openEpisodeDetails(...) pushes tvEpisodeDetails")
    func tvSeasonDetailsOpenEpisodeDetails() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openEpisodeDetails(tvSeriesID: 10, seasonNumber: 2, episodeNumber: 5)

        #expect(
            router.path == [
                .tvEpisodeDetails(tvSeriesID: 10, seasonNumber: 2, episodeNumber: 5)
            ]
        )
    }

    // MARK: - TVEpisodeDetailsNavigating

    @Test("tv episode details openTVEpisodeCastAndCrew(...) pushes tvEpisodeCastAndCrew")
    func tvEpisodeDetailsOpenCastAndCrew() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openTVEpisodeCastAndCrew(tvSeriesID: 10, seasonNumber: 2, episodeNumber: 5)

        #expect(
            router.path == [
                .tvEpisodeCastAndCrew(tvSeriesID: 10, seasonNumber: 2, episodeNumber: 5)
            ]
        )
    }

    // MARK: - Cast & Crew (Movie / TV Series / TV Episode)

    @Test("cast and crew openPersonDetails(id:transitionID:) pushes personDetails dropping the transitionID")
    func castAndCrewOpenPersonDetailsDropsTransitionID() {
        let router = SearchRouter()
        let navigator = SearchRouterNavigator(router: router)

        navigator.openPersonDetails(id: 314, transitionID: "314")

        #expect(router.path == [.personDetails(id: 314)])
    }

}
