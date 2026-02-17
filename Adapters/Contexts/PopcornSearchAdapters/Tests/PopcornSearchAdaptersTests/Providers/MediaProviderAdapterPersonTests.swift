//
//  MediaProviderAdapterPersonTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication
import PeopleApplication
@testable import PopcornSearchAdapters
import SearchDomain
import Testing
import TVSeriesApplication

@Suite("MediaProviderAdapter Person Tests")
struct MediaProviderAdapterPersonTests {

    let mockFetchMovieUseCase: MockFetchMovieDetailsUseCase
    let mockFetchTVSeriesUseCase: MockFetchTVSeriesDetailsUseCase
    let mockFetchPersonUseCase: MockFetchPersonDetailsUseCase

    init() {
        self.mockFetchMovieUseCase = MockFetchMovieDetailsUseCase()
        self.mockFetchTVSeriesUseCase = MockFetchTVSeriesDetailsUseCase()
        self.mockFetchPersonUseCase = MockFetchPersonDetailsUseCase()
    }

    @Test("person returns PersonPreview from use case")
    func personReturnsPersonPreviewFromUseCase() async throws {
        let profilePath = try #require(URL(string: "https://tmdb.example/profile.jpg"))
        let profileURLSet = makeImageURLSet(path: profilePath)

        let personDetails = PersonDetails(
            id: 555,
            name: "John Doe",
            biography: "A talented actor",
            knownForDepartment: "Acting",
            gender: .male,
            profileURLSet: profileURLSet
        )

        mockFetchPersonUseCase.executeStub = .success(personDetails)

        let adapter = makeAdapter()

        let result = try await adapter.person(withID: 555)

        #expect(result.id == 555)
        #expect(result.name == "John Doe")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.profilePath == profilePath)
        #expect(mockFetchPersonUseCase.executeCallCount == 1)
        #expect(mockFetchPersonUseCase.executeCalledWith[0].id == 555)
    }

    @Test("person returns PersonPreview with nil URL when URLSet is nil")
    func personReturnsPersonPreviewWithNilURLWhenURLSetIsNil() async throws {
        let personDetails = PersonDetails(
            id: 666,
            name: "Jane Doe",
            biography: "A talented director",
            knownForDepartment: "Directing",
            gender: .female,
            profileURLSet: nil
        )

        mockFetchPersonUseCase.executeStub = .success(personDetails)

        let adapter = makeAdapter()

        let result = try await adapter.person(withID: 666)

        #expect(result.id == 666)
        #expect(result.profilePath == nil)
    }

    @Test("person throws notFound error from use case")
    func personThrowsNotFoundErrorFromUseCase() async {
        mockFetchPersonUseCase.executeStub = .failure(.notFound)

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.person(withID: 999)
            },
            throws: { error in
                guard let error = error as? MediaProviderError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("person throws unauthorised error from use case")
    func personThrowsUnauthorisedErrorFromUseCase() async {
        mockFetchPersonUseCase.executeStub = .failure(.unauthorised)

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.person(withID: 999)
            },
            throws: { error in
                guard let error = error as? MediaProviderError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("person throws unknown error from use case")
    func personThrowsUnknownErrorFromUseCase() async {
        mockFetchPersonUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = makeAdapter()

        await #expect(
            performing: {
                try await adapter.person(withID: 999)
            },
            throws: { error in
                guard let error = error as? MediaProviderError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("person preserves all gender types")
    func personPreservesAllGenderTypes() async throws {
        let genderCases: [Gender] = [.unknown, .female, .male, .other]

        for gender in genderCases {
            let personDetails = PersonDetails(
                id: 100 + gender.hashValue,
                name: "Test Person",
                biography: "Test biography",
                knownForDepartment: "Acting",
                gender: gender,
                profileURLSet: nil
            )

            mockFetchPersonUseCase.executeStub = .success(personDetails)

            let adapter = makeAdapter()
            let result = try await adapter.person(withID: 100 + gender.hashValue)

            #expect(result.gender == gender)
        }
    }

}

private extension MediaProviderAdapterPersonTests {

    struct TestError: Error {}

    func makeAdapter() -> MediaProviderAdapter {
        MediaProviderAdapter(
            fetchMovieUseCase: mockFetchMovieUseCase,
            fetchTVSeriesUseCase: mockFetchTVSeriesUseCase,
            fetchPersonUseCase: mockFetchPersonUseCase
        )
    }

    func makeImageURLSet(path: URL) -> ImageURLSet {
        ImageURLSet(
            path: path,
            thumbnail: path,
            card: path,
            detail: path,
            full: path
        )
    }

}
