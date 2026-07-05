//
//  MoviePreviewTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingDomain

@Suite("MoviePreview")
struct MoviePreviewTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let posterPath = URL(string: "/poster.jpg")
        let backdropPath = URL(string: "/backdrop.jpg")

        let moviePreview = MoviePreview(
            id: 550,
            title: "Fight Club",
            overview: "An insomniac office worker and a soap salesman build a fight club.",
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        #expect(moviePreview.id == 550)
        #expect(moviePreview.title == "Fight Club")
        #expect(moviePreview.overview == "An insomniac office worker and a soap salesman build a fight club.")
        #expect(moviePreview.posterPath == posterPath)
        #expect(moviePreview.backdropPath == backdropPath)
    }

    @Test("posterPath and backdropPath default to nil when omitted")
    func imagePathsDefaultToNilWhenOmitted() {
        let moviePreview = MoviePreview(id: 1, title: "Test Movie", overview: "Overview")

        #expect(moviePreview.posterPath == nil)
        #expect(moviePreview.backdropPath == nil)
    }

    @Test("instances with equal properties are equal")
    func instancesWithEqualPropertiesAreEqual() {
        let first = MoviePreview(id: 1, title: "Test Movie", overview: "Overview")
        let second = MoviePreview(id: 1, title: "Test Movie", overview: "Overview")

        #expect(first == second)
    }

    @Test("instances with different properties are not equal")
    func instancesWithDifferentPropertiesAreNotEqual() {
        let first = MoviePreview(id: 1, title: "Test Movie", overview: "Overview")
        let second = MoviePreview(id: 2, title: "Test Movie", overview: "Overview")

        #expect(first != second)
    }

}
