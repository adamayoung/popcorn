//
//  TVSeasonPreviewMapperTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesDetailsFeature

@Suite("TVSeasonPreviewMapper Tests")
struct TVSeasonPreviewMapperTests {

    private let mapper = TVSeasonPreviewMapper()

    @Test("Maps TVSeasonSummary to TVSeasonPreview with all properties")
    func mapsTVSeasonSummaryWithAllProperties() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster-full.jpg"))
        )
        let summary = TVSeasonSummary(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterURLSet: posterURLSet
        )

        let result = mapper.map(summary)

        #expect(result.id == 77680)
        #expect(result.name == "Season 1")
        #expect(result.seasonNumber == 1)
        #expect(result.posterURL == posterURLSet.detail)
    }

    @Test("Maps TVSeasonSummary with nil posterURLSet")
    func mapsTVSeasonSummaryWithNilPosterURLSet() {
        let summary = TVSeasonSummary(
            id: 100,
            name: "Specials",
            seasonNumber: 0
        )

        let result = mapper.map(summary)

        #expect(result.id == 100)
        #expect(result.name == "Specials")
        #expect(result.seasonNumber == 0)
        #expect(result.posterURL == nil)
    }

    @Test("Maps multiple TVSeasonSummary values correctly")
    func mapsMultipleTVSeasonSummaries() throws {
        let posterURLSet1 = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster1-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster1-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster1-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster1-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster1-full.jpg"))
        )
        let posterURLSet2 = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster2-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster2-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster2-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster2-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster2-full.jpg"))
        )
        let summaries = [
            TVSeasonSummary(id: 1, name: "Season 1", seasonNumber: 1, posterURLSet: posterURLSet1),
            TVSeasonSummary(id: 2, name: "Season 2", seasonNumber: 2, posterURLSet: posterURLSet2)
        ]

        let results = summaries.map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].seasonNumber == 1)
        #expect(results[0].posterURL == posterURLSet1.detail)
        #expect(results[1].id == 2)
        #expect(results[1].seasonNumber == 2)
        #expect(results[1].posterURL == posterURLSet2.detail)
    }

}
