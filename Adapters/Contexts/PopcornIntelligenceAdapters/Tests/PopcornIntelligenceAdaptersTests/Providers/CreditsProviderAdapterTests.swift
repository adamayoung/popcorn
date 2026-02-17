//
//  CreditsProviderAdapterTests.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
import MoviesApplication
@testable import PopcornIntelligenceAdapters
import Testing

@Suite("CreditsProviderAdapter Tests")
struct CreditsProviderAdapterTests {

    @Test("Returns mapped credits when use case succeeds")
    func returnsMappedCreditsWhenUseCaseSucceeds() async throws {
        let castProfileURLSet = try makeImageURLSet(path: "cast_profile.jpg")
        let crewProfileURLSet = try makeImageURLSet(path: "crew_profile.jpg")

        let castMember = CastMemberDetails(
            id: "cast-123",
            personID: 456,
            characterName: "Tyler Durden",
            personName: "Brad Pitt",
            profileURLSet: castProfileURLSet,
            gender: .male,
            order: 0
        )

        let crewMember = CrewMemberDetails(
            id: "crew-789",
            personID: 101,
            personName: "David Fincher",
            job: "Director",
            profileURLSet: crewProfileURLSet,
            gender: .male,
            department: "Directing"
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [castMember],
            crew: [crewMember]
        )

        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .success(creditsDetails)

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        let result = try await adapter.credits(forMovie: 550)

        #expect(mockUseCase.executeCalledWithMovieID == 550)
        #expect(result.id == 550)
        #expect(result.cast.count == 1)
        #expect(result.crew.count == 1)

        let mappedCast = try #require(result.cast.first)
        #expect(mappedCast.id == "cast-123")
        #expect(mappedCast.personID == 456)
        #expect(mappedCast.characterName == "Tyler Durden")
        #expect(mappedCast.personName == "Brad Pitt")
        #expect(mappedCast.profilePath == castProfileURLSet.path)
        #expect(mappedCast.gender == .male)
        #expect(mappedCast.order == 0)

        let mappedCrew = try #require(result.crew.first)
        #expect(mappedCrew.id == "crew-789")
        #expect(mappedCrew.personID == 101)
        #expect(mappedCrew.personName == "David Fincher")
        #expect(mappedCrew.job == "Director")
        #expect(mappedCrew.profilePath == crewProfileURLSet.path)
        #expect(mappedCrew.gender == .male)
        #expect(mappedCrew.department == "Directing")
    }

    @Test("Throws notFound error when use case throws notFound")
    func throwsNotFoundErrorWhenUseCaseThrowsNotFound() async throws {
        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .failure(.notFound)

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        var thrownError: CreditsProviderError?
        do {
            _ = try await adapter.credits(forMovie: 999)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithMovieID == 999)
        let error = try #require(thrownError)
        guard case .notFound = error else {
            Issue.record("Expected notFound error but got \(error)")
            return
        }
    }

    @Test("Throws unauthorised error when use case throws unauthorised")
    func throwsUnauthorisedErrorWhenUseCaseThrowsUnauthorised() async throws {
        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .failure(.unauthorised)

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        var thrownError: CreditsProviderError?
        do {
            _ = try await adapter.credits(forMovie: 550)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithMovieID == 550)
        let error = try #require(thrownError)
        guard case .unauthorised = error else {
            Issue.record("Expected unauthorised error but got \(error)")
            return
        }
    }

    @Test("Throws unknown error when use case throws unknown")
    func throwsUnknownErrorWhenUseCaseThrowsUnknown() async throws {
        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .failure(.unknown(TestError.generic))

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        var thrownError: CreditsProviderError?
        do {
            _ = try await adapter.credits(forMovie: 550)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithMovieID == 550)
        let error = try #require(thrownError)
        guard case .unknown = error else {
            Issue.record("Expected unknown error but got \(error)")
            return
        }
    }

    @Test("Passes correct movie ID to use case")
    func passesCorrectMovieIDToUseCase() async throws {
        let creditsDetails = CreditsDetails(
            id: 12345,
            cast: [],
            crew: []
        )

        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .success(creditsDetails)

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        _ = try await adapter.credits(forMovie: 12345)

        #expect(mockUseCase.executeCalledWithMovieID == 12345)
    }

    @Test("Maps credits with empty cast and crew arrays")
    func mapsCreditsWithEmptyCastAndCrewArrays() async throws {
        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [],
            crew: []
        )

        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .success(creditsDetails)

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        let result = try await adapter.credits(forMovie: 550)

        #expect(result.cast.isEmpty)
        #expect(result.crew.isEmpty)
    }

    @Test("Maps credits with nil profile URLs")
    func mapsCreditsWithNilProfileURLs() async throws {
        let castMember = CastMemberDetails(
            id: "cast-123",
            personID: 456,
            characterName: "Character",
            personName: "Actor",
            profileURLSet: nil,
            gender: .unknown,
            order: 0
        )

        let crewMember = CrewMemberDetails(
            id: "crew-789",
            personID: 101,
            personName: "Crew",
            job: "Job",
            profileURLSet: nil,
            gender: .unknown,
            department: "Department"
        )

        let creditsDetails = CreditsDetails(
            id: 550,
            cast: [castMember],
            crew: [crewMember]
        )

        let mockUseCase = MockFetchMovieCreditsUseCase()
        mockUseCase.result = .success(creditsDetails)

        let adapter = CreditsProviderAdapter(fetchMovieCreditsUseCase: mockUseCase)

        let result = try await adapter.credits(forMovie: 550)

        #expect(result.cast.first?.profilePath == nil)
        #expect(result.crew.first?.profilePath == nil)
    }

}

// MARK: - Test Helpers

extension CreditsProviderAdapterTests {

    private func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)")),
            thumbnail: #require(URL(string: "https://image.tmdb.org/t/p/w92/\(path)")),
            card: #require(URL(string: "https://image.tmdb.org/t/p/w342/\(path)")),
            detail: #require(URL(string: "https://image.tmdb.org/t/p/w500/\(path)")),
            full: #require(URL(string: "https://image.tmdb.org/t/p/original/\(path)"))
        )
    }

}

// MARK: - Test Error

private enum TestError: Error {
    case generic
}
