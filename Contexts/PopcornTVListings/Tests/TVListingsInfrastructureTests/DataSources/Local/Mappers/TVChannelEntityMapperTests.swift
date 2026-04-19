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
        let entity = TVChannelEntity(
            channelID: "BBC",
            name: "BBC One HD",
            isHD: true,
            logoURL: URL(string: "https://example.com/logo.png")
        )
        let numbers = [TVChannelNumberEntity(channelID: "BBC", channelNumber: "101", subbouquetIDs: [1, 4])]

        let channel = mapper.map(entity, numbers: numbers)

        #expect(channel.id == "BBC")
        #expect(channel.name == "BBC One HD")
        #expect(channel.isHD == true)
        #expect(channel.logoURL == URL(string: "https://example.com/logo.png"))
        #expect(channel.channelNumbers.count == 1)
        #expect(channel.channelNumbers.first?.channelNumber == "101")
        #expect(channel.channelNumbers.first?.subbouquetIDs == [1, 4])
    }

    @Test("maps domain to entity without channel numbers")
    func mapsDomainToEntityWithoutChannelNumbers() {
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
    }

    @Test("mapNumbers produces entities carrying the channel id foreign key")
    func mapNumbersProducesEntitiesWithChannelIDForeignKey() {
        let channel = TVChannel(
            id: "ITV",
            name: "ITV",
            isHD: false,
            logoURL: nil,
            channelNumbers: [
                TVChannelNumber(channelNumber: "103", subbouquetIDs: [1]),
                TVChannelNumber(channelNumber: "3", subbouquetIDs: [2, 3])
            ]
        )

        let numbers = mapper.mapNumbers(for: channel)

        #expect(numbers.count == 2)
        #expect(numbers.allSatisfy { $0.channelID == "ITV" })
        #expect(numbers.map(\.channelNumber) == ["103", "3"])
    }

    @Test("roundtrip preserves values when numbers are supplied separately")
    func roundtripPreservesValuesWhenNumbersSuppliedSeparately() {
        let original = TVChannel(
            id: "C4",
            name: "Channel 4 HD",
            isHD: true,
            logoURL: nil,
            channelNumbers: [TVChannelNumber(channelNumber: "104", subbouquetIDs: [1, 2])]
        )

        let entity = mapper.map(original)
        let numbers = mapper.mapNumbers(for: original)
        let roundtripped = mapper.map(entity, numbers: numbers)

        #expect(roundtripped == original)
    }

}
