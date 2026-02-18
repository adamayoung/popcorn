//
//  ExploreScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class ExploreScreen: Screen {

    override var uniqueElement: XCUIElement {
        view
    }

    func discoverMovieTitle(index: Int = 0) -> String {
        scrollTo(discoverMoviesCarousel)
        XCTAssertTrue(discoverMoviesCarousel.waitForExistence(timeout: 2))
        return discoverMovie(at: index).label
    }

    func trendingMovieTitle(index: Int = 0) -> String {
        scrollTo(trendingMoviesCarousel)
        XCTAssertTrue(trendingMoviesCarousel.waitForExistence(timeout: 2))
        return trendingMovie(at: index).label
    }

    func popularMovieTitle(index: Int = 0) -> String {
        scrollTo(popularMoviesCarousel)
        XCTAssertTrue(popularMoviesCarousel.waitForExistence(timeout: 2))
        return popularMovie(at: index).label
    }

    func trendingTVSeriesName(index: Int = 0) -> String {
        scrollTo(trendingTVSeriesCarousel)
        XCTAssertTrue(trendingTVSeriesCarousel.waitForExistence(timeout: 2))
        return trendingTVSeries(at: index).label
    }

    func trendingPersonName(index: Int = 0) -> String {
        scrollTo(trendingPeopleCarousel)
        XCTAssertTrue(trendingPeopleCarousel.waitForExistence(timeout: 2))
        return trendingPerson(at: index).label
    }

    @discardableResult
    func tapOnDiscoverMovie(index: Int = 0) -> MovieDetailsScreen {
        scrollTo(discoverMoviesCarousel)
        XCTAssertTrue(discoverMoviesCarousel.waitForExistence(timeout: 2))
        discoverMovie(at: index).tap()
        return MovieDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnTrendingMovie(index: Int = 0) -> MovieDetailsScreen {
        scrollTo(trendingMoviesCarousel)
        XCTAssertTrue(trendingMoviesCarousel.waitForExistence(timeout: 2))
        trendingMovie(at: index).tap()
        return MovieDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnPopularMovie(index: Int = 0) -> MovieDetailsScreen {
        scrollTo(popularMoviesCarousel)
        XCTAssertTrue(popularMoviesCarousel.waitForExistence(timeout: 2))
        popularMovie(at: index).tap()
        return MovieDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnTrendingTVSeries(index: Int = 0) -> TVSeriesDetailsScreen {
        scrollTo(trendingTVSeriesCarousel)
        XCTAssertTrue(trendingTVSeriesCarousel.waitForExistence(timeout: 2))
        trendingTVSeries(at: index).tap()
        return TVSeriesDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnTrendingPerson(index: Int = 0) -> PersonDetailsScreen {
        scrollTo(trendingPeopleCarousel)
        XCTAssertTrue(trendingPeopleCarousel.waitForExistence(timeout: 2))
        trendingPerson(at: index).tap()
        return PersonDetailsScreen(app: app)
    }

}

extension ExploreScreen {

    private var view: XCUIElement {
        app.scrollViews["explore.view"]
    }

    private var discoverMoviesCarousel: XCUIElement {
        app.scrollViews["explore.discover-movies.carousel"]
    }

    private func discoverMovie(at index: Int) -> XCUIElement {
        discoverMoviesCarousel.buttons["explore.discover-movies.movie.\(index)"]
    }

    private var trendingMoviesCarousel: XCUIElement {
        app.scrollViews["explore.trending-movies.carousel"]
    }

    private func trendingMovie(at index: Int) -> XCUIElement {
        trendingMoviesCarousel.buttons["explore.trending-movies.movie.\(index)"]
    }

    private var popularMoviesCarousel: XCUIElement {
        app.scrollViews["explore.popular-movies.carousel"]
    }

    private func popularMovie(at index: Int) -> XCUIElement {
        popularMoviesCarousel.buttons["explore.popular-movies.movie.\(index)"]
    }

    private var trendingTVSeriesCarousel: XCUIElement {
        app.scrollViews["explore.trending-tv-series.carousel"]
    }

    private func trendingTVSeries(at index: Int) -> XCUIElement {
        trendingTVSeriesCarousel.buttons["explore.trending-tv-series.tv-series.\(index)"]
    }

    private var trendingPeopleCarousel: XCUIElement {
        app.scrollViews["explore.trending-people.carousel"]
    }

    private func trendingPerson(at index: Int) -> XCUIElement {
        trendingPeopleCarousel.buttons["explore.trending-people.person.\(index)"]
    }

}
