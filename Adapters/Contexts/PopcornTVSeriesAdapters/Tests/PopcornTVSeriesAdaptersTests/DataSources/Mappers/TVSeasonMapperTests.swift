//
//  TVSeasonMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("TVSeasonMapper Tests")
struct TVSeasonMapperTests {

    private let mapper = TVSeasonMapper()

    @Test("Maps all properties from TMDb TV season to domain model")
    func mapsAllProperties() throws {
        let posterPath = try #require(URL(string: "/fOaUnQwDJV22esXEswhaDMSqn2w.jpg"))

        let dto = TMDb.TVSeason(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterPath: posterPath
        )

        let result = mapper.map(dto)

        #expect(result.id == 77680)
        #expect(result.name == "Season 1")
        #expect(result.seasonNumber == 1)
        #expect(result.posterPath == posterPath)
    }

    @Test("Maps with nil posterPath")
    func mapsWithNilPosterPath() {
        let dto = TMDb.TVSeason(
            id: 77680,
            name: "Season 1",
            seasonNumber: 1,
            posterPath: nil
        )

        let result = mapper.map(dto)

        #expect(result.posterPath == nil)
    }

    @Test("Maps season with zero season number")
    func mapsSeasonWithZeroSeasonNumber() {
        let dto = TMDb.TVSeason(
            id: 77679,
            name: "Specials",
            seasonNumber: 0
        )

        let result = mapper.map(dto)

        #expect(result.seasonNumber == 0)
    }

    @Test("Preserves exact id, name, and seasonNumber values")
    func preservesExactValues() {
        let dto = TMDb.TVSeason(
            id: 83248,
            name: "Stranger Things 2",
            seasonNumber: 2
        )

        let result = mapper.map(dto)

        #expect(result.id == 83248)
        #expect(result.name == "Stranger Things 2")
        #expect(result.seasonNumber == 2)
    }

}
