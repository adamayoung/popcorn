//
//  MovieToolMapperTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import Testing

@testable import IntelligenceInfrastructure

@Suite("MovieToolMapper")
struct MovieToolMapperTests {

    let mapper = MovieToolMapper()

    @Test("map returns correct id")
    func mapReturnsCorrectID() {
        let movie = Movie.mock(id: 123)

        let result = mapper.map(movie)

        #expect(result.id == 123)
    }

    @Test("map returns correct title")
    func mapReturnsCorrectTitle() {
        let movie = Movie.mock(title: "The Matrix")

        let result = mapper.map(movie)

        #expect(result.title == "The Matrix")
    }

    @Test("map returns correct overview")
    func mapReturnsCorrectOverview() {
        let movie = Movie.mock(overview: "A computer hacker learns about the true nature of reality")

        let result = mapper.map(movie)

        #expect(result.overview == "A computer hacker learns about the true nature of reality")
    }

    @Test("map returns formatted release date when present")
    func mapReturnsFormattedReleaseDateWhenPresent() {
        let releaseDate = Date(timeIntervalSince1970: 1_609_459_200) // Jan 1, 2021
        let movie = Movie.mock(releaseDate: releaseDate)

        let result = mapper.map(movie)

        #expect(result.releaseDate != nil)
    }

    @Test("map returns nil release date when not present")
    func mapReturnsNilReleaseDateWhenNotPresent() {
        let movie = Movie.mock(releaseDate: nil)

        let result = mapper.map(movie)

        #expect(result.releaseDate == nil)
    }

}
