//
//  CrewMemberDetailsMapperTests.swift
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

@Suite("CrewMemberDetailsMapperTests")
struct CrewMemberDetailsMapperTests {

    let imagesConfiguration: ImagesConfiguration

    init() {
        self.imagesConfiguration = ImagesConfiguration.mock()
    }

    @Test("map should return crew member details with resolved profile URL set")
    func map_shouldReturnCrewMemberDetailsWithResolvedProfileURLSet() {
        let crewMember = CrewMember.mock(
            id: "1-crew",
            personID: 55,
            personName: "Christopher Storer",
            job: "Creator",
            profilePath: URL(string: "/profile.jpg"),
            gender: .male,
            department: "Production"
        )
        let mapper = CrewMemberDetailsMapper()

        let result = mapper.map(crewMember, imagesConfiguration: imagesConfiguration)

        let expectedProfileURLSet = imagesConfiguration.profileURLSet(for: crewMember.profilePath)

        #expect(result.id == crewMember.id)
        #expect(result.personID == crewMember.personID)
        #expect(result.personName == crewMember.personName)
        #expect(result.job == crewMember.job)
        #expect(result.profileURLSet == expectedProfileURLSet)
        #expect(result.gender == crewMember.gender)
        #expect(result.department == crewMember.department)
    }

    @Test("map should return nil profile URL set when profile path is nil")
    func map_shouldReturnNilProfileURLSetWhenProfilePathIsNil() {
        let crewMember = CrewMember.mock(profilePath: nil)
        let mapper = CrewMemberDetailsMapper()

        let result = mapper.map(crewMember, imagesConfiguration: imagesConfiguration)

        #expect(result.profileURLSet == nil)
    }

}
