//
//  EPGRegionMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsDomain

@Suite("EPGRegionMapper")
struct EPGRegionMapperTests {

    let mapper = EPGRegionMapper()

    @Test("maps all region fields to domain")
    func mapsAllFieldsToDomain() {
        let dto = EPGRegionDTO(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)

        let region = mapper.map(dto)

        #expect(region.bouquet == 4101)
        #expect(region.subBouquet == 1)
        #expect(region.name == "London")
        #expect(region.nation == "England")
        #expect(region.isHD == true)
    }

    @Test("preserves an SD region's resolution flag")
    func preservesSDResolution() {
        let dto = EPGRegionDTO(bouquet: 4097, subBouquet: 1, name: "London", nation: "England", isHD: false)

        #expect(mapper.map(dto).isHD == false)
    }

}
