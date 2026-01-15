//
//  TVSeriesMapperTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesApplication

@testable import TVSeriesDetailsFeature

@Suite("TVSeriesMapper Tests")
struct TVSeriesMapperTests {

    private let mapper = TVSeriesMapper()

    @Test("Maps TVSeriesDetails to TVSeries with all properties")
    func mapsTVSeriesDetailsWithAllProperties() throws {
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
        let logoURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/logo-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/logo-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/logo-card.jpg")),
            detail: #require(URL(string: "https://example.com/logo-detail.jpg")),
            full: #require(URL(string: "https://example.com/logo-full.jpg"))
        )

        let details = TVSeriesDetails(
            id: 1399,
            name: "Game of Thrones",
            tagline: "Winter is Coming",
            overview: "A fantasy epic about noble houses fighting for control.",
            numberOfSeasons: 8,
            firstAirDate: Date(timeIntervalSince1970: 1_302_739_200),
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.overview == "A fantasy epic about noble houses fighting for control.")
        #expect(result.posterURL == URL(string: "https://example.com/poster-detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/backdrop-full.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/logo-detail.jpg"))
    }

    @Test("Maps TVSeriesDetails with nil URL sets")
    func mapsTVSeriesDetailsWithNilURLSets() {
        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview",
            numberOfSeasons: 1
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Series")
        #expect(result.overview == "Test overview")
        #expect(result.posterURL == nil)
        #expect(result.backdropURL == nil)
        #expect(result.logoURL == nil)
    }

    @Test("Maps multiple TV series correctly")
    func mapsMultipleTVSeries() {
        let details1 = TVSeriesDetails(id: 1, name: "Series 1", overview: "Overview 1", numberOfSeasons: 1)
        let details2 = TVSeriesDetails(id: 2, name: "Series 2", overview: "Overview 2", numberOfSeasons: 2)

        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Series 1")
        #expect(results[1].id == 2)
        #expect(results[1].name == "Series 2")
    }

}
