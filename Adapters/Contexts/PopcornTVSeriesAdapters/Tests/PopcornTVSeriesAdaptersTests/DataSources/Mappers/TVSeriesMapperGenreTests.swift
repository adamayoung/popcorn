//
//  TVSeriesMapperGenreTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("TVSeriesMapper Genre Tests")
struct TVSeriesMapperGenreTests {

    private let mapper = TVSeriesMapper()

    @Test("Maps genres from TMDb TV series")
    func mapsGenres() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            genres: [
                TMDb.Genre(id: 18, name: "Drama"),
                TMDb.Genre(id: 80, name: "Crime")
            ]
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.genres?.count == 2)
        #expect(result.genres?[0].id == 18)
        #expect(result.genres?[0].name == "Drama")
        #expect(result.genres?[1].id == 80)
        #expect(result.genres?[1].name == "Crime")
    }

    @Test("Maps nil genres to nil")
    func mapsNilGenresToNil() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            genres: nil
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.genres == nil)
    }

    @Test("Maps empty genres array to empty array")
    func mapsEmptyGenresArrayToEmptyArray() {
        let tmdbTVSeries = TMDb.TVSeries(
            id: 1396,
            name: "Breaking Bad",
            overview: "A chemistry teacher...",
            genres: []
        )

        let result = mapper.map(tmdbTVSeries)

        #expect(result.genres?.isEmpty == true)
    }

}
