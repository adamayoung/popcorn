//
//  MoviePreviewDetailsPageTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingApplication

@Suite("MoviePreviewDetailsPage")
struct MoviePreviewDetailsPageTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let movies = [
            MoviePreviewDetails(id: 1, title: "Movie One", overview: "Overview One"),
            MoviePreviewDetails(id: 2, title: "Movie Two", overview: "Overview Two")
        ]

        let page = MoviePreviewDetailsPage(page: 2, totalPages: 5, movies: movies)

        #expect(page.page == 2)
        #expect(page.totalPages == 5)
        #expect(page.movies == movies)
    }

    @Test("instances with equal properties are equal")
    func instancesWithEqualPropertiesAreEqual() {
        let movies = [MoviePreviewDetails(id: 1, title: "Movie One", overview: "Overview One")]
        let first = MoviePreviewDetailsPage(page: 1, totalPages: 3, movies: movies)
        let second = MoviePreviewDetailsPage(page: 1, totalPages: 3, movies: movies)

        #expect(first == second)
    }

    @Test("instances with different properties are not equal")
    func instancesWithDifferentPropertiesAreNotEqual() {
        let movies = [MoviePreviewDetails(id: 1, title: "Movie One", overview: "Overview One")]
        let first = MoviePreviewDetailsPage(page: 1, totalPages: 3, movies: movies)
        let second = MoviePreviewDetailsPage(page: 2, totalPages: 3, movies: movies)

        #expect(first != second)
    }

}
