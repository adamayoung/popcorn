//
//  GenreMapperTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import Testing

@testable import MovieDetailsFeature

@Suite("GenreMapper Tests")
struct GenreMapperTests {

    private let mapper = GenreMapper()

    @Test("Maps genre from MoviesDomain to MovieDetailsFeature")
    func mapsGenre() {
        let domainGenre = MoviesDomain.Genre(id: 28, name: "Action")

        let result = mapper.map(domainGenre)

        #expect(result.id == 28)
        #expect(result.name == "Action")
    }

    @Test("Maps multiple genres correctly")
    func mapsMultipleGenres() {
        let domainGenres = [
            MoviesDomain.Genre(id: 28, name: "Action"),
            MoviesDomain.Genre(id: 878, name: "Science Fiction"),
            MoviesDomain.Genre(id: 53, name: "Thriller")
        ]

        let results = domainGenres.map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 28)
        #expect(results[0].name == "Action")
        #expect(results[1].id == 878)
        #expect(results[1].name == "Science Fiction")
        #expect(results[2].id == 53)
        #expect(results[2].name == "Thriller")
    }

    @Test("Preserves genre properties exactly")
    func preservesGenreProperties() {
        let domainGenre = MoviesDomain.Genre(id: 12345, name: "Test Genre With Special Characters !@#$%")

        let result = mapper.map(domainGenre)

        #expect(result.id == domainGenre.id)
        #expect(result.name == domainGenre.name)
    }

}
