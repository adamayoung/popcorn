//
//  ProductionCountryMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("ProductionCountryMapper Tests")
struct ProductionCountryMapperTests {

    private let mapper = ProductionCountryMapper()

    @Test("Maps all properties from TMDb to domain")
    func mapsAllProperties() {
        let tmdbCountry = TMDb.ProductionCountry(countryCode: "US", name: "United States of America")

        let result = mapper.map(tmdbCountry)

        #expect(result.countryCode == "US")
        #expect(result.name == "United States of America")
    }

    @Test("Maps multiple countries correctly")
    func mapsMultipleCountries() {
        let tmdbCountries = [
            TMDb.ProductionCountry(countryCode: "US", name: "United States of America"),
            TMDb.ProductionCountry(countryCode: "GB", name: "United Kingdom")
        ]

        let results = tmdbCountries.map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].countryCode == "US")
        #expect(results[0].name == "United States of America")
        #expect(results[1].countryCode == "GB")
        #expect(results[1].name == "United Kingdom")
    }

}
