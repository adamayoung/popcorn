//
//  EPGProgrammeMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTVListingsAdapters
import Testing
import TVListingsDomain

@Suite("EPGProgrammeMapper")
struct EPGProgrammeMapperTests {

    let mapper = EPGProgrammeMapper()

    @Test("maps programme DTO to domain with composite id")
    func mapsProgrammeDTOToDomainWithCompositeID() {
        let dto = EPGProgrammeDTO(
            title: "News",
            description: "Evening",
            startTime: 1_776_463_200,
            duration: 1800,
            episodeNumber: 12,
            seasonNumber: 2026,
            imageURL: URL(string: "https://example.com/img.png"),
            tmdbTVSeriesID: 38086,
            tmdbMovieID: nil
        )

        let programme = mapper.map(dto, channelID: "3858")

        #expect(programme.id == "3858:1776463200")
        #expect(programme.channelID == "3858")
        #expect(programme.title == "News")
        #expect(programme.description == "Evening")
        #expect(programme.startTime == Date(timeIntervalSince1970: 1_776_463_200))
        #expect(programme.endTime == Date(timeIntervalSince1970: 1_776_463_200 + 1800))
        #expect(programme.duration == 1800)
        #expect(programme.episodeNumber == 12)
        #expect(programme.seasonNumber == 2026)
        #expect(programme.imageURL == URL(string: "https://example.com/img.png"))
        #expect(programme.tmdbTVSeriesID == 38086)
        #expect(programme.tmdbMovieID == nil)
    }

    @Test("maps missing description to empty string")
    func mapsMissingDescriptionToEmptyString() {
        let dto = EPGProgrammeDTO(
            title: "Untitled",
            description: nil,
            startTime: 1000,
            duration: 60,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )

        let programme = mapper.map(dto, channelID: "X")

        #expect(programme.description == "")
    }

    @Test("preserves optional identifiers when present")
    func preservesOptionalIdentifiersWhenPresent() {
        let dto = EPGProgrammeDTO(
            title: "Film",
            description: nil,
            startTime: 1000,
            duration: 3600,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: 763_285
        )

        let programme = mapper.map(dto, channelID: "C4")

        #expect(programme.tmdbMovieID == 763_285)
    }

}
