//
//  EPGResponseDTOTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing

@Suite("EPGResponseDTO decoding")
struct EPGResponseDTOTests {

    @Test("decodes sample fixture")
    func decodesSampleFixture() throws {
        let data = try FixtureLoader.data(named: "epg-sample")

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        #expect(decoded.channels.count == 2)
    }

    @Test("decodes channel fields including sid and logoURL")
    func decodesChannelFields() throws {
        let data = try FixtureLoader.data(named: "epg-sample")

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)
        let channel = try #require(decoded.channels.first)

        #expect(channel.sid == "3858")
        #expect(channel.name == "SkySp+ HD")
        #expect(channel.isHD == false)
        #expect(channel.logoURL != nil)
        #expect(channel.channelNumbers.count == 1)
        #expect(channel.channelNumbers.first?.channelNumber == "1081")
        #expect(channel.channelNumbers.first?.subbouquetIDs == [1, 4])
    }

    @Test("decodes optional tmdbTVSeriesID when present")
    func decodesTMDbTVSeriesIDWhenPresent() throws {
        let data = try FixtureLoader.data(named: "epg-sample")

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)
        let programmes = decoded.channels[0].schedules[0].programmes

        #expect(programmes[0].tmdbTVSeriesID == nil)
        #expect(programmes[1].tmdbTVSeriesID == 38086)
    }

    @Test("decodes optional seasonNumber when present")
    func decodesSeasonNumberWhenPresent() throws {
        let data = try FixtureLoader.data(named: "epg-sample")

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)
        let channelTwoFirst = decoded.channels[1].schedules[0].programmes[0]
        let channelOneFirst = decoded.channels[0].schedules[0].programmes[0]

        #expect(channelTwoFirst.seasonNumber == 5)
        #expect(channelOneFirst.seasonNumber == nil)
    }

    @Test("decodes programme timing as numeric unix seconds")
    func decodesProgrammeTimingAsUnixSeconds() throws {
        let data = try FixtureLoader.data(named: "epg-sample")

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)
        let programme = decoded.channels[0].schedules[0].programmes[0]

        #expect(programme.startTime == 1_776_461_400)
        #expect(programme.duration == 1800)
    }

    @Test("decodes schedule date as string")
    func decodesScheduleDateAsString() throws {
        let data = try FixtureLoader.data(named: "epg-sample")

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: data)

        #expect(decoded.channels[0].schedules[0].date == "20260418")
    }

    @Test("decodes programme with missing description as nil")
    func decodesProgrammeWithMissingDescriptionAsNil() throws {
        let json = """
        {
            "channels": [{
                "sid": "1",
                "name": "Test",
                "isHD": false,
                "logoURL": "https://example.com/logo.png",
                "channelNumbers": [],
                "schedules": [{
                    "date": "20260101",
                    "programmes": [{
                        "title": "No Description",
                        "startTime": 1000,
                        "duration": 60
                    }]
                }]
            }]
        }
        """

        let decoded = try JSONDecoder().decode(EPGResponseDTO.self, from: Data(json.utf8))
        let programme = decoded.channels[0].schedules[0].programmes[0]

        #expect(programme.description == nil)
        #expect(programme.imageURL == nil)
        #expect(programme.episodeNumber == nil)
    }

}
