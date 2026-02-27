//
//  AggregateCastMemberMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain

@Suite("AggregateCastMemberMapper Tests")
struct AggregateCastMemberMapperTests {

    private let mapper = AggregateCastMemberMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))

        let dto = TMDb.AggregateCastMember(
            id: 17419,
            name: "Millie Bobby Brown",
            originalName: "Millie Bobby Brown",
            gender: .female,
            profilePath: profilePath,
            roles: [
                TMDb.CastRole(creditID: "cr-1", character: "Eleven", episodeCount: 30),
                TMDb.CastRole(creditID: "cr-2", character: "011", episodeCount: 4)
            ],
            knownForDepartment: "Acting",
            isAdultOnly: false,
            totalEpisodeCount: 34,
            popularity: 50.0
        )

        let result = mapper.map(dto)

        #expect(result.id == 17419)
        #expect(result.name == "Millie Bobby Brown")
        #expect(result.profilePath == profilePath)
        #expect(result.gender == .female)
        #expect(result.roles.count == 2)
        #expect(result.roles[0].creditID == "cr-1")
        #expect(result.roles[0].character == "Eleven")
        #expect(result.roles[0].episodeCount == 30)
        #expect(result.roles[1].creditID == "cr-2")
        #expect(result.roles[1].character == "011")
        #expect(result.roles[1].episodeCount == 4)
        #expect(result.totalEpisodeCount == 34)
        #expect(result.initials == "MB")
    }

    @Test("map handles nil profile path")
    func mapHandlesNilProfilePath() {
        let dto = TMDb.AggregateCastMember(
            id: 17419,
            name: "Millie Bobby Brown",
            originalName: "Millie Bobby Brown",
            gender: .female,
            profilePath: nil,
            roles: [TMDb.CastRole(creditID: "cr-1", character: "Eleven", episodeCount: 34)],
            knownForDepartment: "Acting",
            isAdultOnly: false,
            totalEpisodeCount: 34,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.profilePath == nil)
    }

    @Test("map handles nil gender as unknown")
    func mapHandlesNilGenderAsUnknown() {
        let dto = TMDb.AggregateCastMember(
            id: 17419,
            name: "Unknown Person",
            originalName: "Unknown Person",
            gender: .unknown,
            profilePath: nil,
            roles: [TMDb.CastRole(creditID: "cr-1", character: "Character", episodeCount: 1)],
            knownForDepartment: nil,
            isAdultOnly: nil,
            totalEpisodeCount: 1,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.gender == .unknown)
    }

    @Test("map handles empty roles array")
    func mapHandlesEmptyRolesArray() {
        let dto = TMDb.AggregateCastMember(
            id: 17419,
            name: "Millie Bobby Brown",
            originalName: "Millie Bobby Brown",
            gender: .female,
            profilePath: nil,
            roles: [],
            knownForDepartment: "Acting",
            isAdultOnly: false,
            totalEpisodeCount: 0,
            popularity: nil
        )

        let result = mapper.map(dto)

        #expect(result.roles.isEmpty)
        #expect(result.totalEpisodeCount == 0)
    }

}
