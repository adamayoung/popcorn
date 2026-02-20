//
//  TVEpisodeMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("TVEpisodeMapper")
struct TVEpisodeMapperTests {

    let mapper = TVEpisodeMapper()

    @Test("map maps all fields correctly")
    func mapMapsAllFieldsCorrectly() throws {
        let airDate = Date(timeIntervalSince1970: 1_200_528_000)
        let stillPath = try #require(URL(string: "/still.jpg"))

        let dto = TMDb.TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: "A chemistry teacher begins cooking meth.",
            airDate: airDate,
            runtime: 58,
            stillPath: stillPath
        )

        let result = mapper.map(dto)

        #expect(result.id == 62085)
        #expect(result.name == "Pilot")
        #expect(result.episodeNumber == 1)
        #expect(result.seasonNumber == 1)
        #expect(result.overview == "A chemistry teacher begins cooking meth.")
        #expect(result.airDate == airDate)
        #expect(result.runtime == 58)
        #expect(result.stillPath == stillPath)
    }

    @Test("map handles nil optional fields")
    func mapHandlesNilOptionalFields() {
        let dto = TMDb.TVEpisode(
            id: 62085,
            name: "Pilot",
            episodeNumber: 1,
            seasonNumber: 1,
            overview: nil,
            airDate: nil,
            runtime: nil,
            stillPath: nil
        )

        let result = mapper.map(dto)

        #expect(result.id == 62085)
        #expect(result.name == "Pilot")
        #expect(result.overview == nil)
        #expect(result.airDate == nil)
        #expect(result.runtime == nil)
        #expect(result.stillPath == nil)
    }

    @Test("map preserves exact values")
    func mapPreservesExactValues() throws {
        let airDate = Date(timeIntervalSince1970: 1_600_000_000)
        let stillPath = try #require(URL(string: "/specific-path.jpg"))

        let dto = TMDb.TVEpisode(
            id: 999,
            name: "Special Episode",
            episodeNumber: 10,
            seasonNumber: 5,
            overview: "Specific overview text",
            airDate: airDate,
            runtime: 120,
            stillPath: stillPath
        )

        let result = mapper.map(dto)

        #expect(result.id == 999)
        #expect(result.name == "Special Episode")
        #expect(result.episodeNumber == 10)
        #expect(result.seasonNumber == 5)
        #expect(result.overview == "Specific overview text")
        #expect(result.airDate == airDate)
        #expect(result.runtime == 120)
        #expect(result.stillPath == stillPath)
    }

}
