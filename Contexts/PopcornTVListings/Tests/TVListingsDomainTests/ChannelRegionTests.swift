//
//  ChannelRegionTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("ChannelRegion")
struct ChannelRegionTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let region = ChannelRegion(bouquet: 4101, subBouquet: 2)

        #expect(region.bouquet == 4101)
        #expect(region.subBouquet == 2)
    }

    @Test("equality compares bouquet and subBouquet")
    func equalityComparesBouquetAndSubBouquet() {
        #expect(
            ChannelRegion(bouquet: 4101, subBouquet: 1) == ChannelRegion(bouquet: 4101, subBouquet: 1)
        )
        #expect(
            ChannelRegion(bouquet: 4101, subBouquet: 1) != ChannelRegion(bouquet: 4101, subBouquet: 2)
        )
    }

    @Test("Codable round-trips through JSON")
    func codableRoundTrips() throws {
        let region = ChannelRegion(bouquet: 4101, subBouquet: 3)

        let data = try JSONEncoder().encode(region)
        let decoded = try JSONDecoder().decode(ChannelRegion.self, from: data)

        #expect(decoded == region)
    }

    @Test("decodes the feed's bouquet/subBouquet shape")
    func decodesFeedShape() throws {
        let json = Data(#"{ "bouquet": 4109, "subBouquet": 5 }"#.utf8)

        let region = try JSONDecoder().decode(ChannelRegion.self, from: json)

        #expect(region == ChannelRegion(bouquet: 4109, subBouquet: 5))
    }

}
