//
//  EPGChannelMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsDomain

@Suite("EPGChannelMapper")
struct EPGChannelMapperTests {

    let mapper = EPGChannelMapper()

    @Test("maps channel DTO to domain using sid as id")
    func mapsChannelDTOToDomainUsingSidAsID() {
        let dto = EPGChannelDTO(
            sid: "3858",
            name: "SkySp+ HD",
            isHD: true,
            logoURL: URL(string: "https://example.com/logo.png"),
            channelNumbers: [EPGChannelNumberDTO(channelNumber: "1081", subbouquetIDs: [1, 4])],
            schedules: []
        )

        let channel = mapper.map(dto)

        #expect(channel.id == "3858")
        #expect(channel.name == "SkySp+ HD")
        #expect(channel.isHD == true)
        #expect(channel.logoURL == URL(string: "https://example.com/logo.png"))
        #expect(channel.channelNumbers.count == 1)
        #expect(channel.channelNumbers.first?.channelNumber == "1081")
        #expect(channel.channelNumbers.first?.subbouquetIDs == [1, 4])
    }

    @Test("handles empty channel numbers")
    func handlesEmptyChannelNumbers() {
        let dto = EPGChannelDTO(
            sid: "1",
            name: "Test",
            isHD: false,
            logoURL: nil,
            channelNumbers: [],
            schedules: []
        )

        let channel = mapper.map(dto)

        #expect(channel.channelNumbers.isEmpty)
        #expect(channel.logoURL == nil)
    }

}
