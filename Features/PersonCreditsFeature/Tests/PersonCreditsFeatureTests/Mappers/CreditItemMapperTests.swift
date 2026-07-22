//
//  CreditItemMapperTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import PeopleApplication
@testable import PersonCreditsFeature
import Testing

@Suite("CreditItemMapper Tests")
struct CreditItemMapperTests {

    let mapper = CreditItemMapper()

    @Test("maps the item's identity, parts and date")
    func mapsIdentityPartsAndDate() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        let item = PersonCreditItem(
            id: 550,
            mediaType: .movie,
            title: "Fight Club",
            parts: ["The Narrator"],
            date: date
        )

        let result = mapper.map(item)

        #expect(result.mediaID == 550)
        #expect(result.mediaType == .movie)
        #expect(result.title == "Fight Club")
        #expect(result.partsText == "The Narrator")
        #expect(result.date == date)
    }

    @Test("joins multiple parts with a separator")
    func joinsMultiplePartsWithSeparator() {
        let item = PersonCreditItem(
            id: 1,
            mediaType: .movie,
            title: "A",
            parts: ["Tony Stark", "Executive Producer"]
        )

        let result = mapper.map(item)

        #expect(result.partsText == "Tony Stark · Executive Producer")
    }

    @Test("maps empty parts to a nil parts text")
    func mapsEmptyPartsToNil() {
        let item = PersonCreditItem(id: 1, mediaType: .movie, title: "A", parts: [])

        let result = mapper.map(item)

        #expect(result.partsText == nil)
    }

    @Test("uses the card poster URL")
    func usesCardPosterURL() throws {
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let posterURLSet = try #require(ImagesConfiguration.mock().posterURLSet(for: posterPath))
        let item = PersonCreditItem(
            id: 1,
            mediaType: .movie,
            title: "A",
            posterURLSet: posterURLSet
        )

        let result = mapper.map(item)

        #expect(result.posterURL == posterURLSet.card)
    }

    @Test("maps a missing poster URL set to a nil poster URL")
    func mapsMissingPosterURLSetToNil() {
        let item = PersonCreditItem(id: 1, mediaType: .movie, title: "A")

        let result = mapper.map(item)

        #expect(result.posterURL == nil)
    }

    @Test("maps a TV series item's media type")
    func mapsTVSeriesMediaType() {
        let item = PersonCreditItem(id: 1396, mediaType: .tvSeries, title: "Breaking Bad")

        let result = mapper.map(item)

        #expect(result.mediaType == .tvSeries)
    }

}
