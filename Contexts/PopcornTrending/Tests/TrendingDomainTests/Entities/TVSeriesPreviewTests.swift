//
//  TVSeriesPreviewTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TrendingDomain

@Suite("TVSeriesPreview")
struct TVSeriesPreviewTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let posterPath = URL(string: "/poster.jpg")
        let backdropPath = URL(string: "/backdrop.jpg")

        let tvSeriesPreview = TVSeriesPreview(
            id: 1399,
            name: "Game of Thrones",
            overview: "Seven noble families fight for control of the mythical land of Westeros.",
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        #expect(tvSeriesPreview.id == 1399)
        #expect(tvSeriesPreview.name == "Game of Thrones")
        #expect(tvSeriesPreview.overview == "Seven noble families fight for control of the mythical land of Westeros.")
        #expect(tvSeriesPreview.posterPath == posterPath)
        #expect(tvSeriesPreview.backdropPath == backdropPath)
    }

    @Test("posterPath and backdropPath default to nil when omitted")
    func imagePathsDefaultToNilWhenOmitted() {
        let tvSeriesPreview = TVSeriesPreview(id: 1, name: "Test Series", overview: "Overview")

        #expect(tvSeriesPreview.posterPath == nil)
        #expect(tvSeriesPreview.backdropPath == nil)
    }

    @Test("instances with equal properties are equal")
    func instancesWithEqualPropertiesAreEqual() {
        let first = TVSeriesPreview(id: 1, name: "Test Series", overview: "Overview")
        let second = TVSeriesPreview(id: 1, name: "Test Series", overview: "Overview")

        #expect(first == second)
    }

    @Test("instances with different properties are not equal")
    func instancesWithDifferentPropertiesAreNotEqual() {
        let first = TVSeriesPreview(id: 1, name: "Test Series", overview: "Overview")
        let second = TVSeriesPreview(id: 2, name: "Test Series", overview: "Overview")

        #expect(first != second)
    }

}
