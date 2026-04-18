//
//  TVProgrammeEntityMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("TVProgrammeEntityMapper")
struct TVProgrammeEntityMapperTests {

    let mapper = TVProgrammeEntityMapper()

    @Test("maps entity to domain")
    func mapsEntityToDomain() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)
        let end = start.addingTimeInterval(1800)
        let entity = TVProgrammeEntity(
            programmeID: "BBC:1776463200",
            channelID: "BBC",
            title: "News",
            programmeDescription: "Evening news",
            startTime: start,
            endTime: end,
            duration: 1800,
            episodeNumber: 5,
            seasonNumber: 2026,
            imageURL: URL(string: "https://example.com/img.png"),
            tmdbTVSeriesID: 38086,
            tmdbMovieID: nil
        )

        let programme = mapper.map(entity)

        #expect(programme.id == "BBC:1776463200")
        #expect(programme.channelID == "BBC")
        #expect(programme.title == "News")
        #expect(programme.description == "Evening news")
        #expect(programme.startTime == start)
        #expect(programme.endTime == end)
        #expect(programme.duration == 1800)
        #expect(programme.episodeNumber == 5)
        #expect(programme.seasonNumber == 2026)
        #expect(programme.imageURL == URL(string: "https://example.com/img.png"))
        #expect(programme.tmdbTVSeriesID == 38086)
        #expect(programme.tmdbMovieID == nil)
    }

    @Test("maps domain to entity")
    func mapsDomainToEntity() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)
        let end = start.addingTimeInterval(3600)
        let programme = TVProgramme(
            id: "ITV:1776463200",
            channelID: "ITV",
            title: "Drama",
            description: "",
            startTime: start,
            endTime: end,
            duration: 3600,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: 123
        )

        let entity = mapper.map(programme)

        #expect(entity.programmeID == "ITV:1776463200")
        #expect(entity.channelID == "ITV")
        #expect(entity.title == "Drama")
        #expect(entity.programmeDescription == "")
        #expect(entity.startTime == start)
        #expect(entity.endTime == end)
        #expect(entity.duration == 3600)
        #expect(entity.episodeNumber == nil)
        #expect(entity.seasonNumber == nil)
        #expect(entity.imageURL == nil)
        #expect(entity.tmdbTVSeriesID == nil)
        #expect(entity.tmdbMovieID == 123)
    }

    @Test("roundtrip preserves values including nil optionals")
    func roundtripPreservesValuesIncludingNilOptionals() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)
        let original = TVProgramme(
            id: "C4:1776463200",
            channelID: "C4",
            title: "Film",
            description: "Cinema",
            startTime: start,
            endTime: start.addingTimeInterval(7200),
            duration: 7200,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )

        let roundtripped = mapper.map(mapper.map(original))

        #expect(roundtripped == original)
    }

}
