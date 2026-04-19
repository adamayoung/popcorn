//
//  TVChannelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVChannel")
struct TVChannelTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let numbers = [TVChannelNumber(channelNumber: "101", subbouquetIDs: [1, 4])]

        let channel = TVChannel(
            id: "BBC One HD",
            name: "BBC One HD",
            isHD: true,
            logoURL: URL(string: "https://example.com/logo.png"),
            channelNumbers: numbers
        )

        #expect(channel.id == "BBC One HD")
        #expect(channel.name == "BBC One HD")
        #expect(channel.isHD == true)
        #expect(channel.logoURL == URL(string: "https://example.com/logo.png"))
        #expect(channel.channelNumbers == numbers)
    }

    @Test("two channels with identical values are equal")
    func identicalChannelsAreEqual() {
        let lhs = TVChannel(id: "BBC", name: "BBC", isHD: false, logoURL: nil, channelNumbers: [])
        let rhs = TVChannel(id: "BBC", name: "BBC", isHD: false, logoURL: nil, channelNumbers: [])

        #expect(lhs == rhs)
    }

    @Test("channels with different ids are not equal")
    func channelsWithDifferentIDsAreNotEqual() {
        let lhs = TVChannel(id: "BBC", name: "BBC", isHD: false, logoURL: nil, channelNumbers: [])
        let rhs = TVChannel(id: "ITV", name: "BBC", isHD: false, logoURL: nil, channelNumbers: [])

        #expect(lhs != rhs)
    }

}
