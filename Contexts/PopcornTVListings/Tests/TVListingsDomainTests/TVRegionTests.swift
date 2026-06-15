//
//  TVRegionTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVRegion")
struct TVRegionTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let region = TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)

        #expect(region.bouquet == 4101)
        #expect(region.subBouquet == 1)
        #expect(region.name == "London")
        #expect(region.nation == "England")
        #expect(region.isHD == true)
    }

    @Test("id is derived from the bouquet and subBouquet pair")
    func idIsDerivedFromPair() {
        let region = TVRegion(bouquet: 4101, subBouquet: 2, name: "Essex", nation: "England", isHD: true)

        #expect(region.id == "4101-2")
    }

    @Test("the same area in HD and SD bouquets are distinct regions")
    func hdAndSdAreasAreDistinct() {
        let hdRegion = TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        let sdRegion = TVRegion(bouquet: 4097, subBouquet: 1, name: "London", nation: "England", isHD: false)

        #expect(hdRegion != sdRegion)
        #expect(hdRegion.id != sdRegion.id)
    }

}
