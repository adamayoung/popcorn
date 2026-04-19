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
        let number = TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])

        #expect(number.channelNumber == "101")
        #expect(number.subbouquetIDs == [1, 4])
    }

    @Test("equality compares channel number and bouquets")
    func equalityComparesChannelNumberAndBouquets() {
        let lhs = TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])
        let rhs = TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])

        #expect(lhs == rhs)
    }

    @Test("different bouquets are not equal")
    func differentBouquetsAreNotEqual() {
        let lhs = TVChannelNumber(channelNumber: "101", subbouquetIDs: [1])
        let rhs = TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])

        #expect(lhs != rhs)
    }

}
