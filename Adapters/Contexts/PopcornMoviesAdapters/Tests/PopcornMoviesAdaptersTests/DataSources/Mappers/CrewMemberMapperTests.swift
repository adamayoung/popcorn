//
//  CrewMemberMapperTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("CrewMemberMapper Tests")
struct CrewMemberMapperTests {

    private let mapper = CrewMemberMapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let tmdbCrewMember = TMDb.CrewMember(
            id: 7467,
            creditID: "52fe4250c3a36847f8014a05",
            name: "David Fincher",
            job: "Director",
            department: "Directing",
            gender: .male,
            profilePath: profilePath
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.id == "52fe4250c3a36847f8014a05")
        #expect(result.personID == 7467)
        #expect(result.personName == "David Fincher")
        #expect(result.job == "Director")
        #expect(result.profilePath == profilePath)
        #expect(result.gender == .male)
        #expect(result.department == "Directing")
    }

    @Test("map converts female gender correctly")
    func mapConvertsFemaleGenderCorrectly() throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let tmdbCrewMember = TMDb.CrewMember(
            id: 1234,
            creditID: "abc123",
            name: "Jane Doe",
            job: "Producer",
            department: "Production",
            gender: .female,
            profilePath: profilePath
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.gender == .female)
    }

    @Test("map handles nil profile path")
    func mapHandlesNilProfilePath() {
        let tmdbCrewMember = TMDb.CrewMember(
            id: 7467,
            creditID: "52fe4250c3a36847f8014a05",
            name: "David Fincher",
            job: "Director",
            department: "Directing",
            gender: .male,
            profilePath: nil
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.profilePath == nil)
    }

    @Test("map handles default unknown gender")
    func mapHandlesDefaultUnknownGender() {
        let tmdbCrewMember = TMDb.CrewMember(
            id: 7467,
            creditID: "52fe4250c3a36847f8014a05",
            name: "Unknown Crew",
            job: "Writer",
            department: "Writing",
            profilePath: nil
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.gender == .unknown)
    }

    @Test("map converts other gender correctly")
    func mapConvertsOtherGenderCorrectly() {
        let tmdbCrewMember = TMDb.CrewMember(
            id: 100,
            creditID: "def456",
            name: "Crew Member",
            job: "Editor",
            department: "Editing",
            gender: .other,
            profilePath: nil
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.gender == .other)
    }

    @Test("map converts unknown gender correctly")
    func mapConvertsUnknownGenderCorrectly() {
        let tmdbCrewMember = TMDb.CrewMember(
            id: 100,
            creditID: "def456",
            name: "Crew Member",
            job: "Composer",
            department: "Sound",
            gender: .unknown,
            profilePath: nil
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.gender == .unknown)
    }

    @Test("map preserves job and department")
    func mapPreservesJobAndDepartment() {
        let tmdbCrewMember = TMDb.CrewMember(
            id: 1000,
            creditID: "xyz789",
            name: "John Smith",
            job: "Cinematographer",
            department: "Camera",
            gender: .male,
            profilePath: nil
        )

        let result = mapper.map(tmdbCrewMember)

        #expect(result.job == "Cinematographer")
        #expect(result.department == "Camera")
    }

}
