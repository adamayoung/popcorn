//
//  ChannelInitialsTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Testing
@testable import TVListingsFeature

@Suite("ChannelInitials")
struct ChannelInitialsTests {

    @Test
    func multiWordNameTakesFirstLetterOfEachWord() {
        #expect(EPGLayout.channelInitials(for: "BBC One") == "BO")
        #expect(EPGLayout.channelInitials(for: "Channel 4") == "C4")
    }

    @Test
    func singleWordNameTakesFirstLetter() {
        #expect(EPGLayout.channelInitials(for: "ITV1") == "I")
    }

    @Test
    func isCappedAtThreeWords() {
        #expect(EPGLayout.channelInitials(for: "More 4 Films Extra") == "M4F")
    }

    @Test
    func splitsOnHyphens() {
        #expect(EPGLayout.channelInitials(for: "Sky-Sports") == "SS")
    }

    @Test
    func uppercasesLowercaseNames() {
        #expect(EPGLayout.channelInitials(for: "dave ja vu") == "DJV")
    }

    @Test
    func emptyNameReturnsEmptyString() {
        #expect(EPGLayout.channelInitials(for: "") == "")
    }

    @Test
    func nameWithNoLettersFallsBackToFirstTwoCharacters() {
        // No alphabetic split tokens produce a leading letter, so this exercises
        // the prefix(2) fallback path.
        #expect(EPGLayout.channelInitials(for: "   ") == "  ")
    }

}
