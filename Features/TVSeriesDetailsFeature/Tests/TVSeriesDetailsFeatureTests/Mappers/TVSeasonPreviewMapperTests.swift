//
//  TVSeasonPreviewMapperTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesDetailsFeature

@Suite("TVSeasonPreviewMapper Tests")
struct TVSeasonPreviewMapperTests {

    private let mapper = TVSeasonPreviewMapper()

    @Test("Maps TVSeasonSummary to TVSeasonPreview with all properties")
    func mapsTVSeasonSummaryWithAllProperties() throws {
        let posterURL = try #require(URL(string: "https://image.tmdb.org/t/p/w780/poster.jpg"))
        let summary = TVSeasonSummary(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterURL: posterURL
        )

        let result = mapper.map(summary)

        #expect(result.id == 77680)
        #expect(result.name == "Season 1")
        #expect(result.seasonNumber == 1)
        #expect(result.posterURL == posterURL)
    }

    @Test("Maps TVSeasonSummary with nil posterURL")
    func mapsTVSeasonSummaryWithNilPosterURL() {
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
        let posterURL1 = try #require(URL(string: "https://image.tmdb.org/t/p/w780/poster1.jpg"))
        let posterURL2 = try #require(URL(string: "https://image.tmdb.org/t/p/w780/poster2.jpg"))
        let summaries = [
            TVSeasonSummary(id: 1, name: "Season 1", seasonNumber: 1, posterURL: posterURL1),
            TVSeasonSummary(id: 2, name: "Season 2", seasonNumber: 2, posterURL: posterURL2)
        ]

        let results = summaries.map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].seasonNumber == 1)
        #expect(results[0].posterURL == posterURL1)
        #expect(results[1].id == 2)
        #expect(results[1].seasonNumber == 2)
        #expect(results[1].posterURL == posterURL2)
    }

}
