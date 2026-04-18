//
//  TVChannelEntityMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("TVChannelEntityMapper")
struct TVChannelEntityMapperTests {

    let mapper = TVChannelEntityMapper()

    @Test("maps entity to domain")
    func mapsEntityToDomain() {
        let numberEntity = TVChannelNumberEntity(channelNumber: "101", subbouquetIDs: [1, 4])
        let entity = TVChannelEntity(
            channelID: "BBC",
            name: "BBC One HD",
            isHD: true,
            logoURL: URL(string: "https://example.com/logo.png"),
            channelNumbers: [numberEntity]
        )

        let channel = mapper.map(entity)

        #expect(channel.id == "BBC")
        #expect(channel.name == "BBC One HD")
        #expect(channel.isHD == true)
        #expect(channel.logoURL == URL(string: "https://example.com/logo.png"))
        #expect(channel.channelNumbers.count == 1)
        #expect(channel.channelNumbers.first?.channelNumber == "101")
        #expect(channel.channelNumbers.first?.subbouquetIDs == [1, 4])
    }

    @Test("maps domain to entity")
    func mapsDomainToEntity() {
        let channel = TVChannel(
            id: "ITV",
            name: "ITV1 HD",
            isHD: true,
            logoURL: URL(string: "https://example.com/itv.png"),
            channelNumbers: [TVChannelNumber(channelNumber: "103", subbouquetIDs: [1])]
        )

        let entity = mapper.map(channel)

        #expect(entity.channelID == "ITV")
        #expect(entity.name == "ITV1 HD")
        #expect(entity.isHD == true)
        #expect(entity.logoURL == URL(string: "https://example.com/itv.png"))
        #expect(entity.channelNumbers.count == 1)
        #expect(entity.channelNumbers.first?.channelNumber == "103")
        #expect(entity.channelNumbers.first?.subbouquetIDs == [1])
    }

    @Test("roundtrip preserves values")
    func roundtripPreservesValues() {
        let original = TVChannel(
            id: "C4",
            name: "Channel 4 HD",
            isHD: true,
            logoURL: nil,
            channelNumbers: []
        )

        let roundtripped = mapper.map(mapper.map(original))

        #expect(roundtripped == original)
    }

}
