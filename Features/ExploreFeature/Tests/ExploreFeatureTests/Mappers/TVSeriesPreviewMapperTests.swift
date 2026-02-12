//
//  TVSeriesPreviewMapperTests.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
@testable import ExploreFeature
import Foundation
import Testing
import TrendingApplication

@Suite("TVSeriesPreviewMapper Tests")
struct TVSeriesPreviewMapperTests {

    private let mapper = TVSeriesPreviewMapper()

    @Test("Maps TVSeriesPreviewDetails to TVSeriesPreview")
    func mapsTVSeriesPreviewDetails() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster-full.jpg"))
        )
        let backdropURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/backdrop-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/backdrop-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/backdrop-card.jpg")),
            detail: #require(URL(string: "https://example.com/backdrop-detail.jpg")),
            full: #require(URL(string: "https://example.com/backdrop-full.jpg"))
        )

        let details = TVSeriesPreviewDetails(
            id: 1399,
            name: "Game of Thrones",
            overview: "A fantasy epic.",
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.posterURL == URL(string: "https://example.com/poster-detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/backdrop-detail.jpg"))
    }

    @Test("Maps TVSeriesPreviewDetails with nil URL sets")
    func mapsTVSeriesPreviewDetailsWithNilURLSets() {
        let details = TVSeriesPreviewDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview"
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Series")
        #expect(result.posterURL == nil)
        #expect(result.backdropURL == nil)
    }

    @Test("Maps multiple TV series previews correctly")
    func mapsMultipleTVSeriesPreviews() {
        let details1 = TVSeriesPreviewDetails(id: 1, name: "Series 1", overview: "Overview 1")
        let details2 = TVSeriesPreviewDetails(id: 2, name: "Series 2", overview: "Overview 2")

        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Series 1")
        #expect(results[1].id == 2)
        #expect(results[1].name == "Series 2")
    }

}
