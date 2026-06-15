//
//  TVChannelNumberTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVChannelNumber")
struct TVChannelNumberTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let regions = [TVChannelRegion(bouquet: 4101, subBouquet: 1)]
        let number = TVChannelNumber(channelNumber: "101", regions: regions)

        #expect(number.channelNumber == "101")
        #expect(number.regions == regions)
    }

    @Test("equality compares channel number and regions")
    func equalityComparesChannelNumberAndRegions() {
        let regions = [TVChannelRegion(bouquet: 4101, subBouquet: 1)]
        let lhs = TVChannelNumber(channelNumber: "101", regions: regions)
        let rhs = TVChannelNumber(channelNumber: "101", regions: regions)

        #expect(lhs == rhs)
    }

    @Test("different regions are not equal")
    func differentRegionsAreNotEqual() {
        let lhs = TVChannelNumber(channelNumber: "101", regions: [TVChannelRegion(bouquet: 4101, subBouquet: 1)])
        let rhs = TVChannelNumber(channelNumber: "101", regions: [TVChannelRegion(bouquet: 4097, subBouquet: 1)])

        #expect(lhs != rhs)
    }

}
