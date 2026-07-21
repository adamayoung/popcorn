//
//  MoviePreviewPageTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingDomain

@Suite("MoviePreviewPage")
struct MoviePreviewPageTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let movies = [
            MoviePreview(id: 1, title: "Movie One", overview: "Overview One"),
            MoviePreview(id: 2, title: "Movie Two", overview: "Overview Two")
        ]

        let page = MoviePreviewPage(page: 2, totalPages: 5, movies: movies)

        #expect(page.page == 2)
        #expect(page.totalPages == 5)
        #expect(page.movies == movies)
    }

    @Test("instances with equal properties are equal")
    func instancesWithEqualPropertiesAreEqual() {
        let movies = [MoviePreview(id: 1, title: "Movie One", overview: "Overview One")]
        let first = MoviePreviewPage(page: 1, totalPages: 3, movies: movies)
        let second = MoviePreviewPage(page: 1, totalPages: 3, movies: movies)

        #expect(first == second)
    }

    @Test("instances with different properties are not equal")
    func instancesWithDifferentPropertiesAreNotEqual() {
        let movies = [MoviePreview(id: 1, title: "Movie One", overview: "Overview One")]
        let first = MoviePreviewPage(page: 1, totalPages: 3, movies: movies)
        let second = MoviePreviewPage(page: 2, totalPages: 3, movies: movies)

        #expect(first != second)
    }

}
