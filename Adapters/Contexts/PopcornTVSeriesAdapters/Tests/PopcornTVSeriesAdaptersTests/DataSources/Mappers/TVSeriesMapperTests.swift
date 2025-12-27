//
//  TVSeriesMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import Testing
import TMDb
import TVSeriesDomain

@testable import PopcornTVSeriesAdapters

@Suite("TVSeriesMapper Tests")
struct TVSeriesMapperTests {

    @Test("map converts TMDb TV series to domain model")
    func map_convertsTMDbTVSeriesToDomainModel() throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000)
        let tmdbTVSeries = TMDb.TVSeries(
            id: 501,
            name: "Blue Planet",
            overview: "Ocean wildlife",
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        let mapper = TVSeriesMapper()
        let result = mapper.map(tmdbTVSeries)

        #expect(result == TVSeries(
            id: 501,
            name: "Blue Planet",
            overview: "Ocean wildlife",
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        ))
    }

}
