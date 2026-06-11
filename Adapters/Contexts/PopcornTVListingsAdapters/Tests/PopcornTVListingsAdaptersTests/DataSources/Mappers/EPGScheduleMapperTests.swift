//
//  EPGScheduleMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsDomain

@Suite("EPGScheduleMapper")
struct EPGScheduleMapperTests {

    let mapper = EPGScheduleMapper()

    @Test("flattens channels into programmes carrying the channel id")
    func flattensChannelsIntoProgrammes() {
        let dto = EPGScheduleResponseDTO(
            date: "20260418",
            channels: [
                EPGScheduleChannelDTO(sid: "3858", programmes: [.mock(title: "A", startTime: 1000)]),
                EPGScheduleChannelDTO(sid: "4011", programmes: [.mock(title: "B", startTime: 2000)])
            ]
        )

        let programmes = mapper.map(dto)

        #expect(programmes.count == 2)
        #expect(programmes.map(\.channelID) == ["3858", "4011"])
        #expect(programmes.map(\.title) == ["A", "B"])
    }

    @Test("deduplicates programmes with the same id within the file")
    func deduplicatesWithinFile() {
        // Same channel + start time → same composite programme id.
        let dto = EPGScheduleResponseDTO(
            date: "20260418",
            channels: [
                EPGScheduleChannelDTO(
                    sid: "3858",
                    programmes: [.mock(title: "First", startTime: 1000), .mock(title: "Dupe", startTime: 1000)]
                )
            ]
        )

        let programmes = mapper.map(dto)

        #expect(programmes.count == 1)
        #expect(programmes.first?.title == "First")
    }

}
