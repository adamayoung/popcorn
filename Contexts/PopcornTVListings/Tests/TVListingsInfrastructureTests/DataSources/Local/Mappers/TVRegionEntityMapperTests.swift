//
//  TVRegionEntityMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("TVRegionEntityMapper")
struct TVRegionEntityMapperTests {

    let mapper = TVRegionEntityMapper()

    @Test("maps entity to domain")
    func mapsEntityToDomain() {
        let entity = TVRegionEntity(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)

        let region = mapper.map(entity)

        #expect(region.bouquet == 4101)
        #expect(region.subBouquet == 1)
        #expect(region.name == "London")
        #expect(region.nation == "England")
        #expect(region.isHD == true)
    }

    @Test("roundtrips domain through entity")
    func roundtripsDomainThroughEntity() {
        let original = TVRegion(bouquet: 4097, subBouquet: 2, name: "Essex", nation: "England", isHD: false)

        let roundtripped = mapper.map(mapper.map(original))

        #expect(roundtripped == original)
    }

}
