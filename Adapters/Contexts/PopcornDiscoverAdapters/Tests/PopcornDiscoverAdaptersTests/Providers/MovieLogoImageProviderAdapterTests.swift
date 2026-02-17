//
//  MovieLogoImageProviderAdapterTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation
import MoviesApplication
@testable import PopcornDiscoverAdapters
import Testing

@Suite("MovieLogoImageProviderAdapter Tests")
struct MovieLogoImageProviderAdapterTests {

    let mockUseCase: MockFetchMovieImageCollectionUseCase

    init() {
        self.mockUseCase = MockFetchMovieImageCollectionUseCase()
    }

    @Test("imageURLSet returns first logo from use case")
    func imageURLSet_returnsFirstLogoFromUseCase() async throws {
        let movieID = 550
        let logoURLSet = try makeImageURLSet(path: "https://example.com/logo1.png")
        let secondLogoURLSet = try makeImageURLSet(path: "https://example.com/logo2.png")

        let imageCollection = ImageCollectionDetails(
            id: movieID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: [logoURLSet, secondLogoURLSet]
        )

        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: movieID)

        #expect(mockUseCase.executeCallCount == 1)
        #expect(mockUseCase.executeCalledWith[0] == movieID)
        #expect(result == logoURLSet)
    }

    @Test("imageURLSet returns nil when no logos available")
    func imageURLSet_returnsNilWhenNoLogosAvailable() async throws {
        let movieID = 550

        let imageCollection = try ImageCollectionDetails(
            id: movieID,
            posterURLSets: [makeImageURLSet(path: "https://example.com/poster.jpg")],
            backdropURLSets: [makeImageURLSet(path: "https://example.com/backdrop.jpg")],
            logoURLSets: []
        )

        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: movieID)

        #expect(result == nil)
    }

    @Test("imageURLSet throws notFound error from use case")
    func imageURLSet_throwsNotFoundErrorFromUseCase() async {
        let movieID = 999

        mockUseCase.executeStub = .failure(.notFound)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.imageURLSet(forMovie: movieID)
            },
            throws: { error in
                guard let error = error as? MovieLogoImageProviderError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("imageURLSet throws unauthorised error from use case")
    func imageURLSet_throwsUnauthorisedErrorFromUseCase() async {
        let movieID = 550

        mockUseCase.executeStub = .failure(.unauthorised)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.imageURLSet(forMovie: movieID)
            },
            throws: { error in
                guard let error = error as? MovieLogoImageProviderError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("imageURLSet throws unknown error from use case for unknown error")
    func imageURLSet_throwsUnknownErrorFromUseCaseForUnknownError() async {
        let movieID = 550

        mockUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        await #expect(
            performing: {
                try await adapter.imageURLSet(forMovie: movieID)
            },
            throws: { error in
                guard let error = error as? MovieLogoImageProviderError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

}

// MARK: - Test Helpers

private extension MovieLogoImageProviderAdapterTests {

    struct TestError: Error {}

    func makeImageURLSet(path: String) throws -> ImageURLSet {
        try ImageURLSet(
            path: #require(URL(string: path)),
            thumbnail: #require(URL(string: "\(path)?size=thumbnail")),
            card: #require(URL(string: "\(path)?size=card")),
            detail: #require(URL(string: "\(path)?size=detail")),
            full: #require(URL(string: "\(path)?size=full"))
        )
    }

}
