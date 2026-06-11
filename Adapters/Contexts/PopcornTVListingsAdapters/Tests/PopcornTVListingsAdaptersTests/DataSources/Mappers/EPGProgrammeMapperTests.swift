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
        let dto = EPGProgrammeDTO.mock(
            title: "News",
            description: "Evening",
            startTime: 1_776_463_200,
            duration: 1800,
            episodeNumber: 12,
            seasonNumber: 2026,
            imageURL: URL(string: "https://example.com/img.png"),
            tmdbTVSeriesID: 38086
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

    @Test("maps enrichment fields when present")
    func mapsEnrichmentFieldsWhenPresent() {
        let dto = EPGProgrammeDTO.mock(
            genres: ["Comedy", "Drama"],
            certification: "15",
            voteAverage: 7.604,
            voteCount: 1424,
            isPremiere: true,
            keywords: ["hotel", "whodunit"],
            watchProviders: ["Sky Go", "Now TV"]
        )

        let programme = mapper.map(dto, channelID: "SKY")

        #expect(programme.genres == ["Comedy", "Drama"])
        #expect(programme.certification == "15")
        #expect(programme.voteAverage == 7.604)
        #expect(programme.voteCount == 1424)
        #expect(programme.isPremiere == true)
        #expect(programme.keywords == ["hotel", "whodunit"])
        #expect(programme.watchProviders == ["Sky Go", "Now TV"])
    }

    @Test("defaults omitted enrichment fields and description")
    func defaultsOmittedEnrichmentFields() {
        let dto = EPGProgrammeDTO.mock(description: nil)

        let programme = mapper.map(dto, channelID: "X")

        #expect(programme.description == "")
        #expect(programme.genres.isEmpty)
        #expect(programme.certification == nil)
        #expect(programme.voteAverage == nil)
        #expect(programme.voteCount == nil)
        #expect(programme.isPremiere == false)
        #expect(programme.keywords.isEmpty)
        #expect(programme.watchProviders.isEmpty)
    }

    @Test("preserves a movie identifier when present")
    func preservesMovieIdentifierWhenPresent() {
        let dto = EPGProgrammeDTO.mock(tmdbMovieID: 763_285)

        let programme = mapper.map(dto, channelID: "C4")

        #expect(programme.tmdbMovieID == 763_285)
    }

}
