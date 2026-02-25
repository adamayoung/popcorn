//
//  CreditsDetailsMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TVSeriesApplication
import TVSeriesDomain

@Suite("CreditsDetailsMapperTests")
struct CreditsDetailsMapperTests {

    let imagesConfiguration: ImagesConfiguration

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
    }

    @Test("map should return credits details with resolved image URLs")
    func map_shouldReturnCreditsDetailsWithResolvedImageURLs() {
        let credits = Credits.mock()
        let mapper = CreditsDetailsMapper()

        let result = mapper.map(credits, imagesConfiguration: imagesConfiguration)

        #expect(result.id == credits.id)
        #expect(result.cast.count == credits.cast.count)
        #expect(result.crew.count == credits.crew.count)

        for (index, castMember) in credits.cast.enumerated() {
            let expectedProfileURLSet = imagesConfiguration.profileURLSet(
                for: castMember.profilePath
            )
            #expect(result.cast[index].id == castMember.id)
            #expect(result.cast[index].personID == castMember.personID)
            #expect(result.cast[index].profileURLSet == expectedProfileURLSet)
        }

        for (index, crewMember) in credits.crew.enumerated() {
            let expectedProfileURLSet = imagesConfiguration.profileURLSet(
                for: crewMember.profilePath
            )
            #expect(result.crew[index].id == crewMember.id)
            #expect(result.crew[index].personID == crewMember.personID)
            #expect(result.crew[index].profileURLSet == expectedProfileURLSet)
        }
    }

    @Test("map should return empty cast and crew when credits has empty arrays")
    func map_shouldReturnEmptyCastAndCrewWhenCreditsHasEmptyArrays() {
        let credits = Credits.mock(cast: [], crew: [])
        let mapper = CreditsDetailsMapper()

        let result = mapper.map(credits, imagesConfiguration: imagesConfiguration)

        #expect(result.id == credits.id)
        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

}
