//
//  KnownForItemMapperTests.swift
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

@Suite("KnownForItemMapper")
struct KnownForItemMapperTests {

    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("map maps a movie credit's fields")
    func mapMapsMovieCreditFields() throws {
        let credit = PersonCredit.mock(
            id: 42,
            mediaType: .movie,
            title: "Big",
            backdropPath: URL(string: "/backdrop.jpg")
        )
        let logoURLSet = try #require(imagesConfiguration.logoURLSet(for: URL(string: "/logo.png")))

        let mapper = KnownForItemMapper()

        let result = mapper.map(credit, imagesConfiguration: imagesConfiguration, logoURLSet: logoURLSet)

        #expect(result.id == 42)
        #expect(result.mediaType == .movie)
        #expect(result.title == "Big")
        #expect(result.backdropURLSet == imagesConfiguration.backdropURLSet(for: URL(string: "/backdrop.jpg")))
        #expect(result.logoURLSet == logoURLSet)
    }

    @Test("map maps a TV series credit's media type")
    func mapMapsTVSeriesCreditMediaType() {
        let credit = PersonCredit.mock(id: 7, mediaType: .tvSeries, title: "Fringe")

        let mapper = KnownForItemMapper()

        let result = mapper.map(credit, imagesConfiguration: imagesConfiguration, logoURLSet: nil)

        #expect(result.mediaType == .tvSeries)
        #expect(result.title == "Fringe")
    }

    @Test("map yields a nil backdrop URL set when the backdrop path is nil")
    func mapYieldsNilBackdropWhenPathNil() {
        let credit = PersonCredit.mock(backdropPath: nil)

        let mapper = KnownForItemMapper()

        let result = mapper.map(credit, imagesConfiguration: imagesConfiguration, logoURLSet: nil)

        #expect(result.backdropURLSet == nil)
    }

    @Test("map yields a nil logo URL set when no logo is provided")
    func mapYieldsNilLogoWhenNotProvided() {
        let credit = PersonCredit.mock()

        let mapper = KnownForItemMapper()

        let result = mapper.map(credit, imagesConfiguration: imagesConfiguration, logoURLSet: nil)

        #expect(result.logoURLSet == nil)
    }

}
