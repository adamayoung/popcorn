//
//  ExploreRouterTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import Popcorn
import Testing

@MainActor
@Suite("ExploreRouter Tests")
struct ExploreRouterTests {

    // MARK: - ExploreNavigating (home)

    @Test("home openTrendingMovies() pushes trendingMovies")
    func homeOpenTrendingMoviesPushesRoute() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openTrendingMovies()

        #expect(router.path == [.trendingMovies])
        #expect(router.presentedMovieIntelligence == nil)
        #expect(router.presentedTVSeriesIntelligence == nil)
    }

    @Test("home openMovieDetails(id:transitionID:) pushes movieDetails forwarding the transitionID")
    func homeOpenMovieDetailsForwardsTransitionID() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openMovieDetails(id: 42, transitionID: "movie-42")

        #expect(router.path == [.movieDetails(id: 42, transitionID: "movie-42")])
        #expect(router.presentedMovieIntelligence == nil)
        #expect(router.presentedTVSeriesIntelligence == nil)
    }

    @Test("home openTVSeriesDetails(id:transitionID:) pushes tvSeriesDetails forwarding the transitionID")
    func homeOpenTVSeriesDetailsForwardsTransitionID() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openTVSeriesDetails(id: 7, transitionID: "tv-7")

        #expect(router.path == [.tvSeriesDetails(id: 7, transitionID: "tv-7")])
    }

    @Test("home openPersonDetails(id:transitionID:) pushes personDetails forwarding the transitionID")
    func homeOpenPersonDetailsForwardsTransitionID() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openPersonDetails(id: 99, transitionID: "person-99")

        #expect(router.path == [.personDetails(id: 99, transitionID: "person-99")])
    }

    // MARK: - MovieDetailsNavigating

    @Test("movie details openMovieDetails(id:) pushes movieDetails with a nil transitionID")
    func movieDetailsOpenMovieDetailsNilTransitionID() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openMovieDetails(id: 11)

        #expect(router.path == [.movieDetails(id: 11, transitionID: nil)])
    }

    @Test("movie details openMovieCastAndCrew(movieID:) pushes movieCastAndCrew")
    func movieDetailsOpenCastAndCrew() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openMovieCastAndCrew(movieID: 123)

        #expect(router.path == [.movieCastAndCrew(movieID: 123)])
    }

    @Test("movie details openMovieIntelligence(id:) presents the modal and does not push")
    func movieDetailsOpenIntelligencePresentsModal() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openMovieIntelligence(id: 555)

        #expect(router.presentedMovieIntelligence?.movieID == 555)
        #expect(router.path.isEmpty)
    }

    // MARK: - TVSeriesDetailsNavigating

    @Test("tv series details openTVSeriesDetails(id:) pushes tvSeriesDetails with a nil transitionID")
    func tvSeriesDetailsOpenTVSeriesDetailsNilTransitionID() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openTVSeriesDetails(id: 22)

        #expect(router.path == [.tvSeriesDetails(id: 22, transitionID: nil)])
    }

    @Test("tv series details openSeasonDetails(tvSeriesID:seasonNumber:) pushes tvSeasonDetails")
    func tvSeriesDetailsOpenSeasonDetails() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openSeasonDetails(tvSeriesID: 10, seasonNumber: 2)

        #expect(router.path == [.tvSeasonDetails(tvSeriesID: 10, seasonNumber: 2)])
    }

    @Test("tv series details openTVSeriesCastAndCrew(tvSeriesID:) pushes tvSeriesCastAndCrew")
    func tvSeriesDetailsOpenCastAndCrew() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openTVSeriesCastAndCrew(tvSeriesID: 88)

        #expect(router.path == [.tvSeriesCastAndCrew(tvSeriesID: 88)])
    }

    @Test("tv series details openTVSeriesIntelligence(id:) presents the modal and does not push")
    func tvSeriesDetailsOpenIntelligencePresentsModal() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openTVSeriesIntelligence(id: 777)

        #expect(router.presentedTVSeriesIntelligence?.tvSeriesID == 777)
        #expect(router.path.isEmpty)
    }

    // MARK: - TVSeasonDetailsNavigating

    @Test("tv season details openEpisodeDetails(...) pushes tvEpisodeDetails")
    func tvSeasonDetailsOpenEpisodeDetails() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

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
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        navigator.openTVEpisodeCastAndCrew(tvSeriesID: 10, seasonNumber: 2, episodeNumber: 5)

        #expect(
            router.path == [
                .tvEpisodeCastAndCrew(tvSeriesID: 10, seasonNumber: 2, episodeNumber: 5)
            ]
        )
    }

    // MARK: - Cast & Crew (Movie / TV Series / TV Episode)

    @Test("cast & crew person navigation pushes without a transition id (no zoom)")
    func castAndCrewOpenPersonDetailsHasNoTransitionID() {
        let router = ExploreRouter()
        let navigator = ExploreRouterNavigator(router: router)

        // Cast & crew view models call the shared openPersonDetails with `nil`
        // (their transition source is in a different namespace), so the route
        // carries no transition id and the destination pushes without a zoom.
        navigator.openPersonDetails(id: 314, transitionID: nil)

        #expect(router.path == [.personDetails(id: 314, transitionID: nil)])
    }

}
