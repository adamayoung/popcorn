//
//  TVSeriesMapperTests.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TVSeriesApplication
@testable import TVSeriesIntelligenceFeature

@Suite("TVSeriesMapper Tests")
struct TVSeriesMapperTests {

    private let mapper = TVSeriesMapper()

    @Test("Maps TVSeriesDetails to TVSeries")
    func mapsTVSeriesDetails() {
        let details = TVSeriesDetails(
            id: 1399,
            name: "Game of Thrones",
            tagline: "Winter is Coming",
            overview: "A fantasy epic about noble houses fighting for control.",
            numberOfSeasons: 8
        )

        let result = mapper.map(details)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.tagline == "Winter is Coming")
    }

    @Test("Maps TVSeriesDetails with nil tagline")
    func mapsTVSeriesDetailsWithNilTagline() {
        let details = TVSeriesDetails(
            id: 123,
            name: "Test Series",
            tagline: nil,
            overview: "Test overview",
            numberOfSeasons: 1
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Series")
        #expect(result.tagline == nil)
    }

    @Test("Maps multiple TV series correctly")
    func mapsMultipleTVSeries() {
        let details1 = TVSeriesDetails(id: 1, name: "Series 1", tagline: "Tagline 1", overview: "", numberOfSeasons: 1)
        let details2 = TVSeriesDetails(id: 2, name: "Series 2", tagline: "Tagline 2", overview: "", numberOfSeasons: 2)

        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Series 1")
        #expect(results[0].tagline == "Tagline 1")
        #expect(results[1].id == 2)
        #expect(results[1].name == "Series 2")
        #expect(results[1].tagline == "Tagline 2")
    }

}
