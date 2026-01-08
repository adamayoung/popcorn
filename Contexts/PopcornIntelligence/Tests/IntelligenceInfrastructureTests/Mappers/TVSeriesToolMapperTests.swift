//
//  TVSeriesToolMapperTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import Testing

@testable import IntelligenceInfrastructure

@Suite("TVSeriesToolMapper")
struct TVSeriesToolMapperTests {

    let mapper = TVSeriesToolMapper()

    @Test("map returns correct id")
    func mapReturnsCorrectID() {
        let tvSeries = TVSeries.mock(id: 456)

        let result = mapper.map(tvSeries)

        #expect(result.id == 456)
    }

    @Test("map returns correct name")
    func mapReturnsCorrectName() {
        let tvSeries = TVSeries.mock(name: "Breaking Bad")

        let result = mapper.map(tvSeries)

        #expect(result.name == "Breaking Bad")
    }

    @Test("map returns correct tagline when present")
    func mapReturnsCorrectTaglineWhenPresent() {
        let tvSeries = TVSeries.mock(tagline: "All bad things must come to an end")

        let result = mapper.map(tvSeries)

        #expect(result.tagline == "All bad things must come to an end")
    }

    @Test("map returns nil tagline when not present")
    func mapReturnsNilTaglineWhenNotPresent() {
        let tvSeries = TVSeries.mock(tagline: nil)

        let result = mapper.map(tvSeries)

        #expect(result.tagline == nil)
    }

    @Test("map returns correct overview")
    func mapReturnsCorrectOverview() {
        let tvSeries = TVSeries.mock(overview: "A high school chemistry teacher turns to making meth")

        let result = mapper.map(tvSeries)

        #expect(result.overview == "A high school chemistry teacher turns to making meth")
    }

    @Test("map returns correct number of seasons")
    func mapReturnsCorrectNumberOfSeasons() {
        let tvSeries = TVSeries.mock(numberOfSeasons: 5)

        let result = mapper.map(tvSeries)

        #expect(result.numberOfSeasons == 5)
    }

}
