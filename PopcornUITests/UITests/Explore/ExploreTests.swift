//
//  ExploreTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class ExploreTests: PopcornUITestCase {

    override var featureFlags: [String: Bool] {
        [
            "explore": true,
            "explore_discover_movies": true,
            "explore_trending_movies": true,
            "explore_popular_movies": true,
            "explore_trending_tv_series": true,
            "explore_trending_people": true
        ]
    }

    func testNavigateToFirstDiscoverMovie() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let movieTitle = explore.discoverMovieTitle(index: 0)

        let movieDetails = explore.tapOnDiscoverMovie(index: 0)
        movieDetails.assertMovieTitle(movieTitle)
    }

    func testNavigateToFirstTrendingMovie() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let movieTitle = explore.trendingMovieTitle(index: 0)

        let movieDetails = explore.tapOnTrendingMovie(index: 0)
        movieDetails.assertMovieTitle(movieTitle)
    }

    func testNavigateToFirstPopularMovie() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let movieTitle = explore.popularMovieTitle(index: 0)

        let movieDetails = explore.tapOnPopularMovie(index: 0)
        movieDetails.assertMovieTitle(movieTitle)
    }

    func testNavigateToFirstTrendingTVSeries() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let tvSeriesName = explore.trendingTVSeriesName(index: 0)

        let tvSeriesDetails = explore.tapOnTrendingTVSeries(index: 0)
        tvSeriesDetails.assertTVSeriesName(tvSeriesName)
    }

    func testNavigateToFirstTrendingPerson() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let personName = explore.trendingPersonName(index: 0)

        let personDetails = explore.tapOnTrendingPerson(index: 0)
        personDetails.assertPersonName(personName)
    }

}
