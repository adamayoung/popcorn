//
//  ExploreScreen.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
//

import XCTest

@MainActor
final class ExploreScreen: Screen {

    override var uniqueElement: XCUIElement {
        exploreView
    }

    @discardableResult
    func tapOnFirstDiscoverMovie() -> MovieDetailsScreen {
        scrollTo(discoverMoviesCarousel)
        XCTAssertTrue(discoverMoviesCarousel.waitForExistence(timeout: 2))
        discoverMoviesCarousel.buttons.firstMatch.tap()
        return MovieDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnFirstTrendingMovie() -> MovieDetailsScreen {
        scrollTo(trendingMoviesCarousel)
        XCTAssertTrue(trendingMoviesCarousel.waitForExistence(timeout: 2))
        trendingMoviesCarousel.buttons.firstMatch.tap()
        return MovieDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnFirstPopularMovie() -> MovieDetailsScreen {
        scrollTo(popularMoviesCarousel)
        XCTAssertTrue(popularMoviesCarousel.waitForExistence(timeout: 2))
        popularMoviesCarousel.buttons.firstMatch.tap()
        return MovieDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnFirstTrendingTVSeries() -> TVSeriesDetailsScreen {
        scrollTo(trendingTVSeriesCarousel)
        XCTAssertTrue(trendingTVSeriesCarousel.waitForExistence(timeout: 2))
        trendingTVSeriesCarousel.buttons.firstMatch.tap()
        return TVSeriesDetailsScreen(app: app)
    }

    @discardableResult
    func tapOnFirstTrendingPerson() -> PersonDetailsScreen {
        scrollTo(trendingPeopleCarousel)
        XCTAssertTrue(trendingPeopleCarousel.waitForExistence(timeout: 2))
        trendingPeopleCarousel.buttons.firstMatch.tap()
        return PersonDetailsScreen(app: app)
    }

}

extension ExploreScreen {

    private var exploreView: XCUIElement { app.scrollViews["explore.view"] }
    private var discoverMoviesCarousel: XCUIElement { app.scrollViews["explore.discover-movies.carousel"] }
    private var trendingMoviesCarousel: XCUIElement { app.scrollViews["explore.trending-movies.carousel"] }
    private var popularMoviesCarousel: XCUIElement { app.scrollViews["explore.popular-movies.carousel"] }
    private var trendingTVSeriesCarousel: XCUIElement { app.scrollViews["explore.trending-tvseries.carousel"] }
    private var trendingPeopleCarousel: XCUIElement { app.scrollViews["explore.trending-people.carousel"] }

}
