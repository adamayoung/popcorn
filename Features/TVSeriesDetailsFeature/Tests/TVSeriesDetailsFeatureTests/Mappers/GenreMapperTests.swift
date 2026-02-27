//
//  GenreMapperTests.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVSeriesDetailsFeature
import TVSeriesDomain

@Suite("GenreMapper Tests")
struct GenreMapperTests {

    private let mapper = GenreMapper()

    @Test("Maps genre from TVSeriesDomain to TVSeriesDetailsFeature")
    func mapsGenre() {
        let domainGenre = TVSeriesDomain.Genre(id: 18, name: "Drama")

        let result = mapper.map(domainGenre)

        #expect(result.id == 18)
        #expect(result.name == "Drama")
    }

    @Test("Maps multiple genres correctly")
    func mapsMultipleGenres() {
        let domainGenres = [
            TVSeriesDomain.Genre(id: 10765, name: "Sci-Fi & Fantasy"),
            TVSeriesDomain.Genre(id: 18, name: "Drama"),
            TVSeriesDomain.Genre(id: 10759, name: "Action & Adventure")
        ]

        let results = domainGenres.map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 10765)
        #expect(results[0].name == "Sci-Fi & Fantasy")
        #expect(results[1].id == 18)
        #expect(results[1].name == "Drama")
        #expect(results[2].id == 10759)
        #expect(results[2].name == "Action & Adventure")
    }

    @Test("Preserves genre properties exactly")
    func preservesGenreProperties() {
        let domainGenre = TVSeriesDomain.Genre(id: 12345, name: "Test Genre With Special Characters !@#$%")

        let result = mapper.map(domainGenre)

        #expect(result.id == domainGenre.id)
        #expect(result.name == domainGenre.name)
    }

}
