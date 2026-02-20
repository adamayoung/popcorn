//
//  ExploreScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class ExploreScreen: Screen {

    let app: XCUIApplication

    var uniqueElement: XCUIElement {
        view
    }

    init(app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        self.app = app
        assertScreenExists(file: file, line: line)
    }

    func discoverMovieTitle(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> String {
        scrollTo(discoverMoviesCarousel)
        XCTAssertTrue(discoverMoviesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        return discoverMovie(at: index).label
    }

    func trendingMovieTitle(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> String {
        scrollTo(trendingMoviesCarousel)
        XCTAssertTrue(trendingMoviesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        return trendingMovie(at: index).label
    }

    func popularMovieTitle(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> String {
        scrollTo(popularMoviesCarousel)
        XCTAssertTrue(popularMoviesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        return popularMovie(at: index).label
    }

    func trendingTVSeriesName(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> String {
        scrollTo(trendingTVSeriesCarousel)
        XCTAssertTrue(trendingTVSeriesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        return trendingTVSeries(at: index).label
    }

    func trendingPersonName(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> String {
        scrollTo(trendingPeopleCarousel)
        XCTAssertTrue(trendingPeopleCarousel.waitForExistence(timeout: 2), file: file, line: line)
        return trendingPerson(at: index).label
    }

    @discardableResult
    func tapOnDiscoverMovie(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> MovieDetailsScreen {
        scrollTo(discoverMoviesCarousel)
        XCTAssertTrue(discoverMoviesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        discoverMovie(at: index).tap()
        return MovieDetailsScreen(app: app, file: file, line: line)
    }

    @discardableResult
    func tapOnTrendingMovie(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> MovieDetailsScreen {
        scrollTo(trendingMoviesCarousel)
        XCTAssertTrue(trendingMoviesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        trendingMovie(at: index).tap()
        return MovieDetailsScreen(app: app, file: file, line: line)
    }

    @discardableResult
    func tapOnPopularMovie(index: Int = 0, file: StaticString = #filePath, line: UInt = #line) -> MovieDetailsScreen {
        scrollTo(popularMoviesCarousel)
        XCTAssertTrue(popularMoviesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        popularMovie(at: index).tap()
        return MovieDetailsScreen(app: app, file: file, line: line)
    }

    @discardableResult
    func tapOnTrendingTVSeries(
        index: Int = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TVSeriesDetailsScreen {
        scrollTo(trendingTVSeriesCarousel)
        XCTAssertTrue(trendingTVSeriesCarousel.waitForExistence(timeout: 2), file: file, line: line)
        trendingTVSeries(at: index).tap()
        return TVSeriesDetailsScreen(app: app, file: file, line: line)
    }

    @discardableResult
    func tapOnTrendingPerson(
        index: Int = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> PersonDetailsScreen {
        scrollTo(trendingPeopleCarousel)
        XCTAssertTrue(trendingPeopleCarousel.waitForExistence(timeout: 2), file: file, line: line)
        trendingPerson(at: index).tap()
        return PersonDetailsScreen(app: app, file: file, line: line)
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
