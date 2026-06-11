//
//  TVProgrammeTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVProgramme")
struct TVProgrammeTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)
        let end = start.addingTimeInterval(1800)

        let programme = TVProgramme(
            id: "BBC:1776463200",
            channelID: "BBC",
            title: "News",
            description: "Nightly news",
            startTime: start,
            endTime: end,
            duration: 1800,
            episodeNumber: 12,
            seasonNumber: 2026,
            imageURL: URL(string: "https://example.com/img.png"),
            tmdbTVSeriesID: 38086,
            tmdbMovieID: nil,
            genres: ["News"],
            certification: "U",
            voteAverage: 7.6,
            voteCount: 1424,
            isPremiere: true,
            keywords: ["headlines"],
            watchProviders: ["BBC iPlayer"]
        )

        #expect(programme.id == "BBC:1776463200")
        #expect(programme.channelID == "BBC")
        #expect(programme.title == "News")
        #expect(programme.description == "Nightly news")
        #expect(programme.startTime == start)
        #expect(programme.endTime == end)
        #expect(programme.duration == 1800)
        #expect(programme.episodeNumber == 12)
        #expect(programme.seasonNumber == 2026)
        #expect(programme.imageURL == URL(string: "https://example.com/img.png"))
        #expect(programme.tmdbTVSeriesID == 38086)
        #expect(programme.tmdbMovieID == nil)
        #expect(programme.genres == ["News"])
        #expect(programme.certification == "U")
        #expect(programme.voteAverage == 7.6)
        #expect(programme.voteCount == 1424)
        #expect(programme.isPremiere == true)
        #expect(programme.keywords == ["headlines"])
        #expect(programme.watchProviders == ["BBC iPlayer"])
    }

    @Test("init defaults enrichment fields when omitted")
    func initDefaultsEnrichmentFieldsWhenOmitted() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)

        let programme = TVProgramme(
            id: "BBC:1776463200",
            channelID: "BBC",
            title: "News",
            description: "",
            startTime: start,
            endTime: start.addingTimeInterval(1800),
            duration: 1800,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )

        #expect(programme.genres.isEmpty)
        #expect(programme.certification == nil)
        #expect(programme.voteAverage == nil)
        #expect(programme.voteCount == nil)
        #expect(programme.isPremiere == false)
        #expect(programme.keywords.isEmpty)
        #expect(programme.watchProviders.isEmpty)
    }

    @Test("makeID derives the id from channel id and start time")
    func makeIDDerivesTheIDFromChannelIDAndStartTime() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)

        let id = TVProgramme.makeID(channelID: "BBC One HD", startTime: start)

        #expect(id == "BBC One HD:1776463200")
    }

    @Test("makeID floors fractional start times to seconds")
    func makeIDFloorsFractionalStartTimesToSeconds() {
        let start = Date(timeIntervalSince1970: 1_776_463_200.75)

        let id = TVProgramme.makeID(channelID: "BBC", startTime: start)

        #expect(id == "BBC:1776463200")
    }

    @Test("two programmes with identical values are equal")
    func identicalProgrammesAreEqual() {
        let start = Date(timeIntervalSince1970: 1_776_463_200)
        let lhs = TVProgramme(
            id: "BBC:1776463200",
            channelID: "BBC",
            title: "News",
            description: "",
            startTime: start,
            endTime: start.addingTimeInterval(1800),
            duration: 1800,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )
        let rhs = TVProgramme(
            id: "BBC:1776463200",
            channelID: "BBC",
            title: "News",
            description: "",
            startTime: start,
            endTime: start.addingTimeInterval(1800),
            duration: 1800,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )

        #expect(lhs == rhs)
    }

}
