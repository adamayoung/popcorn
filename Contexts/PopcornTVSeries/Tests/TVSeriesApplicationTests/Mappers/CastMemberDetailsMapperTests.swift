//
//  CastMemberDetailsMapperTests.swift
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

@Suite("CastMemberDetailsMapperTests")
struct CastMemberDetailsMapperTests {

    let imagesConfiguration: ImagesConfiguration

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
    }

    @Test("map should return cast member details with resolved profile URL set")
    func map_shouldReturnCastMemberDetailsWithResolvedProfileURLSet() {
        let castMember = CastMember.mock(
            id: "1-cast",
            personID: 42,
            characterName: "Carmy Berzatto",
            personName: "Jeremy Allen White",
            profilePath: URL(string: "/profile.jpg"),
            gender: .male,
            order: 0
        )
        let mapper = CastMemberDetailsMapper()

        let result = mapper.map(castMember, imagesConfiguration: imagesConfiguration)

        let expectedProfileURLSet = imagesConfiguration.profileURLSet(for: castMember.profilePath)

        #expect(result.id == castMember.id)
        #expect(result.personID == castMember.personID)
        #expect(result.characterName == castMember.characterName)
        #expect(result.personName == castMember.personName)
        #expect(result.profileURLSet == expectedProfileURLSet)
        #expect(result.gender == castMember.gender)
        #expect(result.order == castMember.order)
    }

    @Test("map should return nil profile URL set when profile path is nil")
    func map_shouldReturnNilProfileURLSetWhenProfilePathIsNil() {
        let castMember = CastMember.mock(profilePath: nil)
        let mapper = CastMemberDetailsMapper()

        let result = mapper.map(castMember, imagesConfiguration: imagesConfiguration)

        #expect(result.profileURLSet == nil)
    }

}
