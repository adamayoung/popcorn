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
        #expect(dto.files.count == 4)
        #expect(dto.files.first?.path == "channels.json")
        #expect(dto.files.first?.bytes == 18234)
        #expect(dto.files.contains { $0.path == "regions.json" })
    }

    @Test("decodes the channels fixture with region pairs")
    func decodesChannelsFixture() throws {
        let data = try FixtureLoader.data(named: "channels")

        let dto = try JSONDecoder().decode(EPGChannelsResponseDTO.self, from: data)

        #expect(dto.channels.count == 2)
        #expect(dto.channels.first?.sid == "3858")
        #expect(dto.channels.first?.type == "tv")
        #expect(dto.channels.last?.type == "radio")
        #expect(dto.channels.last?.isHD == true)
        let firstRegion = dto.channels.first?.channelNumbers.first?.regions.first
        #expect(firstRegion?.bouquet == 4101)
        #expect(firstRegion?.subBouquet == 1)
    }

    @Test("decodes the regions fixture")
    func decodesRegionsFixture() throws {
        let data = try FixtureLoader.data(named: "regions")

        let dto = try JSONDecoder().decode(EPGRegionsResponseDTO.self, from: data)

        #expect(dto.regions.count == 3)
        let london = dto.regions.first
        #expect(london?.bouquet == 4101)
        #expect(london?.subBouquet == 1)
        #expect(london?.name == "London")
        #expect(london?.nation == "England")
        #expect(london?.isHD == true)
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
