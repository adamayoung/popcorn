//
//  PersonCreditItemMapperTests.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
@testable import PeopleApplication
import PeopleDomain
import Testing

@Suite("PersonCreditItemMapper Tests")
struct PersonCreditItemMapperTests {

    let mapper = PersonCreditItemMapper()

    @Test("maps the title's identity and date from the group")
    func mapsIdentityAndDate() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        let credit = PersonCredit.mock(
            id: 550,
            mediaType: .movie,
            title: "Fight Club",
            releaseDate: date,
            role: .cast(character: "The Narrator")
        )

        let result = mapper.map([credit], imagesConfiguration: ImagesConfiguration.mock())

        #expect(result.id == 550)
        #expect(result.mediaType == .movie)
        #expect(result.title == "Fight Club")
        #expect(result.date == date)
        #expect(result.parts == ["The Narrator"])
    }

    @Test("maps a TV series credit's media type")
    func mapsTVSeriesMediaType() {
        let credit = PersonCredit.mock(id: 1396, mediaType: .tvSeries, title: "Breaking Bad")

        let result = mapper.map([credit], imagesConfiguration: ImagesConfiguration.mock())

        #expect(result.mediaType == .tvSeries)
    }

    @Test("orders parts with cast characters before crew jobs, in encounter order")
    func ordersPartsCharactersBeforeJobs() {
        let credits = [
            PersonCredit.mock(id: 1, role: .crew(job: "Director", department: "Directing")),
            PersonCredit.mock(id: 1, role: .cast(character: "Tony Stark")),
            PersonCredit.mock(id: 1, role: .crew(job: "Executive Producer", department: "Production"))
        ]

        let result = mapper.map(credits, imagesConfiguration: ImagesConfiguration.mock())

        #expect(result.parts == ["Tony Stark", "Director", "Executive Producer"])
    }

    @Test("drops unknown parts and duplicates")
    func dropsUnknownPartsAndDuplicates() {
        let credits = [
            PersonCredit.mock(id: 1, role: .cast(character: nil)),
            PersonCredit.mock(id: 1, role: .crew(job: "Director", department: "Directing")),
            PersonCredit.mock(id: 1, role: .crew(job: "Director", department: "Directing")),
            PersonCredit.mock(id: 1, role: .crew(job: "", department: "Production"))
        ]

        let result = mapper.map(credits, imagesConfiguration: ImagesConfiguration.mock())

        #expect(result.parts == ["Director"])
    }

    @Test("builds the poster URL set from the first credit carrying a poster path")
    func buildsPosterURLSetFromFirstPosterPath() throws {
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let credits = [
            PersonCredit.mock(id: 1, posterPath: nil),
            PersonCredit.mock(id: 1, posterPath: posterPath)
        ]
        let imagesConfiguration = ImagesConfiguration.mock()

        let result = mapper.map(credits, imagesConfiguration: imagesConfiguration)

        #expect(result.posterURLSet == imagesConfiguration.posterURLSet(for: posterPath))
    }

    @Test("maps a group with no poster paths to a nil poster URL set")
    func mapsMissingPosterPathsToNil() {
        let credit = PersonCredit.mock(id: 1, posterPath: nil)

        let result = mapper.map([credit], imagesConfiguration: ImagesConfiguration.mock())

        #expect(result.posterURLSet == nil)
    }

}
