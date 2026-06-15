//
//  ChannelTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("Channel")
struct ChannelTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let numbers = [ChannelNumber(channelNumber: "101", regions: [ChannelRegion(bouquet: 4101, subBouquet: 1)])]

        let channel = Channel(
            id: "BBC One HD",
            name: "BBC One HD",
            type: .television,
            isHD: true,
            logoURL: URL(string: "https://example.com/logo.png"),
            channelNumbers: numbers
        )

        #expect(channel.id == "BBC One HD")
        #expect(channel.name == "BBC One HD")
        #expect(channel.type == .television)
        #expect(channel.isHD == true)
        #expect(channel.logoURL == URL(string: "https://example.com/logo.png"))
        #expect(channel.channelNumbers == numbers)
    }

    @Test("two channels with identical values are equal")
    func identicalChannelsAreEqual() {
        let lhs = Channel(id: "BBC", name: "BBC", type: .television, isHD: false, logoURL: nil, channelNumbers: [])
        let rhs = Channel(id: "BBC", name: "BBC", type: .television, isHD: false, logoURL: nil, channelNumbers: [])

        #expect(lhs == rhs)
    }

    @Test("channels with different ids are not equal")
    func channelsWithDifferentIDsAreNotEqual() {
        let lhs = Channel(id: "BBC", name: "BBC", type: .television, isHD: false, logoURL: nil, channelNumbers: [])
        let rhs = Channel(id: "ITV", name: "BBC", type: .television, isHD: false, logoURL: nil, channelNumbers: [])

        #expect(lhs != rhs)
    }

}
