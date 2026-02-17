//
//  ProductionCompanyMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("ProductionCompanyMapper Tests")
struct ProductionCompanyMapperTests {

    private let mapper = ProductionCompanyMapper()

    @Test("Maps all properties from TMDb to domain")
    func mapsAllProperties() {
        let tmdbCompany = TMDb.ProductionCompany(
            id: 25,
            name: "20th Century Fox",
            originCountry: "US",
            logoPath: URL(string: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
        )

        let result = mapper.map(tmdbCompany)

        #expect(result.id == 25)
        #expect(result.name == "20th Century Fox")
        #expect(result.originCountry == "US")
        #expect(result.logoPath == URL(string: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png"))
    }

    @Test("Maps with nil logo path")
    func mapsWithNilLogoPath() {
        let tmdbCompany = TMDb.ProductionCompany(
            id: 25,
            name: "20th Century Fox",
            originCountry: "US",
            logoPath: nil
        )

        let result = mapper.map(tmdbCompany)

        #expect(result.id == 25)
        #expect(result.name == "20th Century Fox")
        #expect(result.originCountry == "US")
        #expect(result.logoPath == nil)
    }

    @Test("Maps multiple companies correctly")
    func mapsMultipleCompanies() {
        let tmdbCompanies = [
            TMDb.ProductionCompany(id: 25, name: "20th Century Fox", originCountry: "US", logoPath: nil),
            TMDb.ProductionCompany(id: 508, name: "Regency Enterprises", originCountry: "US", logoPath: nil)
        ]

        let results = tmdbCompanies.map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 25)
        #expect(results[1].id == 508)
    }

}
