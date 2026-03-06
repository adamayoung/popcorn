//
//  GenreMapperTests.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import GenresApplication
@testable import MediaSearchFeature
import Testing

@Suite("GenreMapper")
struct GenreMapperTests {

    let mapper = GenreMapper()

    @Test("map maps all properties")
    func mapMapsAllProperties() throws {
        let cardURL = try #require(URL(string: "https://image.tmdb.org/card/backdrop.jpg"))
        let backdropURLSet = try ImageURLSet(
            path: #require(URL(string: "/backdrop.jpg")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/thumb/backdrop.jpg")),
            card: cardURL,
            detail: #require(URL(string: "https://image.tmdb.org/detail/backdrop.jpg")),
            full: #require(URL(string: "https://image.tmdb.org/full/backdrop.jpg"))
        )
        let genreDetails = GenreDetailsExtended(
            id: 28,
            name: "Action",
            color: ThemeColor(red: 1.0, green: 0.23, blue: 0.19),
            backdropURLSet: backdropURLSet
        )

        let result = mapper.map(genreDetails)

        #expect(result.id == 28)
        #expect(result.name == "Action")
        #expect(result.color == ThemeColor(red: 1.0, green: 0.23, blue: 0.19))
        #expect(result.backdropURL == cardURL)
    }

    @Test("map maps nil backdrop")
    func mapMapsNilBackdrop() {
        let genreDetails = GenreDetailsExtended(
            id: 35,
            name: "Comedy",
            color: ThemeColor(red: 0.2, green: 0.78, blue: 0.35)
        )

        let result = mapper.map(genreDetails)

        #expect(result.id == 35)
        #expect(result.backdropURL == nil)
    }

}
