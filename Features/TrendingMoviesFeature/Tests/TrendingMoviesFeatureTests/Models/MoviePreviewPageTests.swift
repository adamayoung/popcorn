//
//  MoviePreviewPageTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingMoviesFeature

@Suite("MoviePreviewPage Tests")
struct MoviePreviewPageTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let movies = [MoviePreview(id: 1, title: "Movie 1")]

        let page = MoviePreviewPage(page: 2, totalPages: 5, movies: movies)

        #expect(page.page == 2)
        #expect(page.totalPages == 5)
        #expect(page.movies == movies)
    }

    @Test("hasMore is true when the current page is before the last")
    func hasMoreTrueWhenBeforeLastPage() {
        let page = MoviePreviewPage(page: 1, totalPages: 3, movies: [])

        #expect(page.hasMore)
    }

    @Test("hasMore is false when the current page is the last")
    func hasMoreFalseWhenLastPage() {
        let page = MoviePreviewPage(page: 3, totalPages: 3, movies: [])

        #expect(page.hasMore == false)
    }

    @Test("hasMore is false when the current page is beyond totalPages")
    func hasMoreFalseWhenBeyondTotalPages() {
        let page = MoviePreviewPage(page: 4, totalPages: 3, movies: [])

        #expect(page.hasMore == false)
    }

}
