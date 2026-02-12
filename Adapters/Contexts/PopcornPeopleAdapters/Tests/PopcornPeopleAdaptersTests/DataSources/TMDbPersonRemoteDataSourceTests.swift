//
//  TMDbPersonRemoteDataSourceTests.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleDomain
import PeopleInfrastructure
@testable import PopcornPeopleAdapters
import Testing
import TMDb

@Suite("TMDbPersonRemoteDataSource Tests")
struct TMDbPersonRemoteDataSourceTests {

    let mockService: MockPersonService

    init() {
        self.mockService = MockPersonService()
    }

    @Test("person maps response and uses en language")
    func person_mapsResponseAndUsesEnglishLanguage() async throws {
        let id = 287
        let profilePath = try #require(URL(string: "/profile/brad-pitt.jpg"))
        let tmdbPerson = TMDb.Person(
            id: id,
            name: "Brad Pitt",
            alsoKnownAs: ["William Bradley Pitt"],
            knownForDepartment: "Acting",
            biography: "William Bradley Pitt is an American actor and film producer.",
            birthday: Date(timeIntervalSince1970: -199_238_400),
            deathday: nil,
            gender: .male,
            placeOfBirth: "Shawnee, Oklahoma, USA",
            profilePath: profilePath,
            popularity: 75.123,
            imdbID: "nm0000093",
            homepageURL: nil
        )

        mockService.detailsStub = .success(tmdbPerson)

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        let result = try await dataSource.person(withID: id)

        #expect(result == PeopleDomain.Person(
            id: id,
            name: "Brad Pitt",
            biography: "William Bradley Pitt is an American actor and film producer.",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: profilePath
        ))
        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0] == .init(id: id, language: "en"))
    }

    @Test("person throws notFound error for TMDb notFound")
    func person_throwsNotFoundErrorForTMDbNotFound() async {
        let id = 999

        mockService.detailsStub = .failure(.notFound())

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        await #expect(
            performing: {
                try await dataSource.person(withID: id)
            },
            throws: { error in
                guard let error = error as? PersonRepositoryError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("person throws unauthorised error for TMDb unauthorised")
    func person_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let id = 287

        mockService.detailsStub = .failure(.unauthorised("Invalid API key"))

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        await #expect(
            performing: {
                try await dataSource.person(withID: id)
            },
            throws: { error in
                guard let error = error as? PersonRepositoryError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("person throws unknown error for other TMDb errors")
    func person_throwsUnknownErrorForOtherTMDbErrors() async {
        let id = 287

        mockService.detailsStub = .failure(.network(TestError()))

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        await #expect(
            performing: {
                try await dataSource.person(withID: id)
            },
            throws: { error in
                guard let error = error as? PersonRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("person maps Tom Hanks data correctly")
    func person_mapsTomHanksDataCorrectly() async throws {
        let id = 31
        let profilePath = try #require(URL(string: "/profile/tom-hanks.jpg"))
        let tmdbPerson = TMDb.Person(
            id: id,
            name: "Tom Hanks",
            alsoKnownAs: ["Thomas Jeffrey Hanks"],
            knownForDepartment: "Acting",
            biography: "Thomas Jeffrey Hanks is an American actor and filmmaker.",
            birthday: Date(timeIntervalSince1970: -425_174_400),
            deathday: nil,
            gender: .male,
            placeOfBirth: "Concord, California, USA",
            profilePath: profilePath,
            popularity: 82.456,
            imdbID: "nm0000158",
            homepageURL: nil
        )

        mockService.detailsStub = .success(tmdbPerson)

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        let result = try await dataSource.person(withID: id)

        #expect(result.id == 31)
        #expect(result.name == "Tom Hanks")
        #expect(result.biography == "Thomas Jeffrey Hanks is an American actor and filmmaker.")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profilePath == profilePath)
    }

    @Test("person maps person with nil optional fields")
    func person_mapsPersonWithNilOptionalFields() async throws {
        let id = 999
        let tmdbPerson = TMDb.Person(
            id: id,
            name: "Unknown Actor",
            alsoKnownAs: nil,
            knownForDepartment: nil,
            biography: nil,
            birthday: nil,
            deathday: nil,
            gender: .unknown,
            placeOfBirth: nil,
            profilePath: nil,
            popularity: nil,
            imdbID: nil,
            homepageURL: nil
        )

        mockService.detailsStub = .success(tmdbPerson)

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        let result = try await dataSource.person(withID: id)

        #expect(result.id == 999)
        #expect(result.name == "Unknown Actor")
        #expect(result.biography == "")
        #expect(result.knownForDepartment == "")
        #expect(result.gender == .unknown)
        #expect(result.profilePath == nil)
    }

    @Test("person correctly passes person ID to service")
    func person_correctlyPassesPersonIDToService() async throws {
        let id = 12345
        let tmdbPerson = TMDb.Person(
            id: id,
            name: "Test Person",
            gender: .male
        )

        mockService.detailsStub = .success(tmdbPerson)

        let dataSource = TMDbPersonRemoteDataSource(personService: mockService)

        _ = try await dataSource.person(withID: id)

        #expect(mockService.detailsCalledWith.count == 1)
        #expect(mockService.detailsCalledWith[0].id == id)
        #expect(mockService.detailsCalledWith[0].language == "en")
    }

}

// MARK: - Test Helpers

private struct TestError: Error {}
