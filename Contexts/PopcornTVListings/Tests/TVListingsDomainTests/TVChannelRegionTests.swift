//
//  TVChannelRegionTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVChannelRegion")
struct TVChannelRegionTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let region = TVChannelRegion(bouquet: 4101, subBouquet: 2)

        #expect(region.bouquet == 4101)
        #expect(region.subBouquet == 2)
    }

    @Test("equality compares bouquet and subBouquet")
    func equalityComparesBouquetAndSubBouquet() {
        #expect(
            TVChannelRegion(bouquet: 4101, subBouquet: 1) == TVChannelRegion(bouquet: 4101, subBouquet: 1)
        )
        #expect(
            TVChannelRegion(bouquet: 4101, subBouquet: 1) != TVChannelRegion(bouquet: 4101, subBouquet: 2)
        )
    }

    @Test("Codable round-trips through JSON")
    func codableRoundTrips() throws {
        let region = TVChannelRegion(bouquet: 4101, subBouquet: 3)

        let data = try JSONEncoder().encode(region)
        let decoded = try JSONDecoder().decode(TVChannelRegion.self, from: data)

        #expect(decoded == region)
    }

    @Test("decodes the feed's bouquet/subBouquet shape")
    func decodesFeedShape() throws {
        let json = Data(#"{ "bouquet": 4109, "subBouquet": 5 }"#.utf8)

        let region = try JSONDecoder().decode(TVChannelRegion.self, from: json)

        #expect(region == TVChannelRegion(bouquet: 4109, subBouquet: 5))
    }

}
