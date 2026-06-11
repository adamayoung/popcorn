//
//  EPGDTODecodingTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing

@Suite("EPG DTO decoding")
struct EPGDTODecodingTests {

    @Test("decodes the manifest fixture")
    func decodesManifestFixture() throws {
        let data = try FixtureLoader.data(named: "manifest")

        let dto = try JSONDecoder().decode(EPGManifestDTO.self, from: data)

        #expect(dto.dates == ["20260418", "20260419"])
        #expect(dto.files.count == 3)
        #expect(dto.files.first?.path == "channels.json")
        #expect(dto.files.first?.bytes == 18234)
    }

    @Test("decodes the channels fixture")
    func decodesChannelsFixture() throws {
        let data = try FixtureLoader.data(named: "channels")

        let dto = try JSONDecoder().decode(EPGChannelsResponseDTO.self, from: data)

        #expect(dto.channels.count == 2)
        #expect(dto.channels.first?.sid == "3858")
        #expect(dto.channels.last?.isHD == true)
    }

    @Test("decodes the schedule fixture including enrichment fields")
    func decodesScheduleFixture() throws {
        let data = try FixtureLoader.data(named: "schedule-20260418")

        let dto = try JSONDecoder().decode(EPGScheduleResponseDTO.self, from: data)

        #expect(dto.date == "20260418")
        #expect(dto.channels.count == 2)
        let firstProgramme = dto.channels.first?.programmes.first
        #expect(firstProgramme?.isPremiere == true)
        #expect(firstProgramme?.genres == ["Sport", "News"])
        #expect(firstProgramme?.voteCount == 1424)
    }

    @Test("omitted optional programme fields decode as nil")
    func omittedOptionalsDecodeAsNil() throws {
        let json = Data(#"{"title":"X","startTime":1000,"duration":60}"#.utf8)

        let dto = try JSONDecoder().decode(EPGProgrammeDTO.self, from: json)

        #expect(dto.description == nil)
        #expect(dto.genres == nil)
        #expect(dto.isPremiere == nil)
        #expect(dto.watchProviders == nil)
    }

}
