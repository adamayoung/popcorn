//
//  KnownForItemMapperTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import PeopleApplication
@testable import PersonDetailsFeature
import Testing

@Suite("KnownForItemMapper Tests")
struct KnownForItemMapperTests {

    private let mapper = KnownForItemMapper()

    @Test("maps a movie item, using the backdrop detail and logo thumbnail URLs")
    func mapsMovieItem() throws {
        let backdrop = try makeURLSet(prefix: "backdrop")
        let logo = try makeURLSet(prefix: "logo")
        let item = PeopleApplication.KnownForItem(
            id: 42,
            mediaType: .movie,
            title: "Big",
            backdropURLSet: backdrop,
            logoURLSet: logo
        )

        let result = mapper.map(item)

        #expect(result.id == 42)
        #expect(result.mediaType == .movie)
        #expect(result.title == "Big")
        #expect(result.backdropURL == backdrop.detail)
        #expect(result.logoURL == logo.thumbnail)
    }

    @Test("maps a TV series item's media type")
    func mapsTVSeriesItem() {
        let item = PeopleApplication.KnownForItem(id: 7, mediaType: .tvSeries, title: "Fringe")

        let result = mapper.map(item)

        #expect(result.mediaType == .tvSeries)
    }

    @Test("maps nil URL sets to nil URLs")
    func mapsNilURLSets() {
        let item = PeopleApplication.KnownForItem(id: 1, mediaType: .movie, title: "A")

        let result = mapper.map(item)

        #expect(result.backdropURL == nil)
        #expect(result.logoURL == nil)
    }

    private func makeURLSet(prefix: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://example.com/\(prefix)/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/\(prefix)/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/\(prefix)/card.jpg")),
            detail: #require(URL(string: "https://example.com/\(prefix)/detail.jpg")),
            full: #require(URL(string: "https://example.com/\(prefix)/full.jpg"))
        )
    }

}
