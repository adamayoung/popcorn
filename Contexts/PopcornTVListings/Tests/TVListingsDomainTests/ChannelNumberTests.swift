//
//  ChannelNumberTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("ChannelNumber")
struct ChannelNumberTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let regions = [ChannelRegion(bouquet: 4101, subBouquet: 1)]
        let number = ChannelNumber(channelNumber: "101", regions: regions)

        #expect(number.channelNumber == "101")
        #expect(number.regions == regions)
    }

    @Test("equality compares channel number and regions")
    func equalityComparesChannelNumberAndRegions() {
        let regions = [ChannelRegion(bouquet: 4101, subBouquet: 1)]
        let lhs = ChannelNumber(channelNumber: "101", regions: regions)
        let rhs = ChannelNumber(channelNumber: "101", regions: regions)

        #expect(lhs == rhs)
    }

    @Test("different regions are not equal")
    func differentRegionsAreNotEqual() {
        let lhs = ChannelNumber(channelNumber: "101", regions: [ChannelRegion(bouquet: 4101, subBouquet: 1)])
        let rhs = ChannelNumber(channelNumber: "101", regions: [ChannelRegion(bouquet: 4097, subBouquet: 1)])

        #expect(lhs != rhs)
    }

}
