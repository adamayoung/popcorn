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
            type: "tv",
            isHD: true,
            logoURL: URL(string: "https://example.com/logo.png"),
            channelNumbers: [
                EPGChannelNumberDTO(
                    channelNumber: "1081",
                    regions: [
                        EPGChannelRegionDTO(bouquet: 4101, subBouquet: 1),
                        EPGChannelRegionDTO(bouquet: 4097, subBouquet: 1)
                    ]
                )
            ]
        )

        let channel = mapper.map(dto)

        #expect(channel.id == "3858")
        #expect(channel.name == "SkySp+ HD")
        #expect(channel.type == .television)
        #expect(channel.isHD == true)
        #expect(channel.logoURL == URL(string: "https://example.com/logo.png"))
        #expect(channel.channelNumbers.count == 1)
        #expect(channel.channelNumbers.first?.channelNumber == "1081")
        #expect(channel.channelNumbers.first?.regions == [
            TVChannelRegion(bouquet: 4101, subBouquet: 1),
            TVChannelRegion(bouquet: 4097, subBouquet: 1)
        ])
    }

    @Test("handles empty channel numbers")
    func handlesEmptyChannelNumbers() {
        let dto = EPGChannelDTO(
            sid: "1",
            name: "Test",
            type: "tv",
            isHD: false,
            logoURL: nil,
            channelNumbers: []
        )

        let channel = mapper.map(dto)

        #expect(channel.channelNumbers.isEmpty)
        #expect(channel.logoURL == nil)
    }

    @Test("maps radio type and falls back to television for an unknown type")
    func mapsChannelType() {
        func channel(type: String) -> TVChannel {
            mapper.map(EPGChannelDTO(sid: "1", name: "X", type: type, isHD: false, logoURL: nil, channelNumbers: []))
        }

        #expect(channel(type: "radio").type == .radio)
        #expect(channel(type: "tv").type == .television)
        #expect(channel(type: "something-new").type == .television)
    }

}
