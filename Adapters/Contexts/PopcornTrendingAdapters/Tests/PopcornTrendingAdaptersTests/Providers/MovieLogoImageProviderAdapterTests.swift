//
//  MovieLogoImageProviderAdapterTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication
@testable import PopcornTrendingAdapters
import Testing
import TrendingDomain

@Suite("MovieLogoImageProviderAdapter Tests")
struct MovieLogoImageProviderAdapterTests {

    let mockUseCase: MockFetchMovieImageCollectionUseCase

    init() {
        self.mockUseCase = MockFetchMovieImageCollectionUseCase()
    }

    @Test("imageURLSet returns first logo URL set when available")
    func imageURLSet_returnsFirstLogoURLSetWhenAvailable() async throws {
        let movieID = 550
        let logoURLSet = try makeImageURLSet(path: "https://example.com/logo.png")
        let imageCollection = ImageCollectionDetails(
            id: movieID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: [logoURLSet]
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: movieID)

        #expect(result == logoURLSet)
        #expect(mockUseCase.executeCallCount == 1)
        #expect(mockUseCase.executeCalledWith[0] == movieID)
    }

    @Test("imageURLSet returns nil when no logo URL sets available")
    func imageURLSet_returnsNilWhenNoLogoURLSetsAvailable() async throws {
        let movieID = 550
        let imageCollection = ImageCollectionDetails(
            id: movieID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: []
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: movieID)

        #expect(result == nil)
    }

    @Test("imageURLSet returns first logo URL set when multiple available")
    func imageURLSet_returnsFirstLogoURLSetWhenMultipleAvailable() async throws {
        let movieID = 550
        let firstLogoURLSet = try makeImageURLSet(path: "https://example.com/logo1.png")
        let secondLogoURLSet = try makeImageURLSet(path: "https://example.com/logo2.png")
        let imageCollection = ImageCollectionDetails(
            id: movieID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: [firstLogoURLSet, secondLogoURLSet]
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: movieID)

        #expect(result == firstLogoURLSet)
    }

    @Test("imageURLSet throws notFound error when use case throws notFound")
    func imageURLSet_throwsNotFoundErrorWhenUseCaseThrowsNotFound() async {
        let movieID = 550
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

    @Test("imageURLSet throws unauthorised error when use case throws unauthorised")
    func imageURLSet_throwsUnauthorisedErrorWhenUseCaseThrowsUnauthorised() async {
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

    @Test("imageURLSet throws unknown error when use case throws unknown")
    func imageURLSet_throwsUnknownErrorWhenUseCaseThrowsUnknown() async {
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

    @Test("imageURLSet passes correct movie ID to use case")
    func imageURLSet_passesCorrectMovieIDToUseCase() async throws {
        let movieID = 12345
        let imageCollection = ImageCollectionDetails(
            id: movieID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: []
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        _ = try await adapter.imageURLSet(forMovie: movieID)

        #expect(mockUseCase.executeCalledWith[0] == movieID)
    }

    @Test("imageURLSet ignores poster and backdrop URL sets")
    func imageURLSet_ignoresPosterAndBackdropURLSets() async throws {
        let movieID = 550
        let posterURLSet = try makeImageURLSet(path: "https://example.com/poster.jpg")
        let backdropURLSet = try makeImageURLSet(path: "https://example.com/backdrop.jpg")
        let imageCollection = ImageCollectionDetails(
            id: movieID,
            posterURLSets: [posterURLSet],
            backdropURLSets: [backdropURLSet],
            logoURLSets: []
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = MovieLogoImageProviderAdapter(fetchImageCollectionUseCase: mockUseCase)

        let result = try await adapter.imageURLSet(forMovie: movieID)

        #expect(result == nil)
    }

}

// MARK: - Test Helpers

private extension MovieLogoImageProviderAdapterTests {

    struct TestError: Error {}

    func makeImageURLSet(path: String) throws -> ImageURLSet {
        let url = try #require(URL(string: path))
        return ImageURLSet(
            path: url,
            thumbnail: url,
            card: url,
            detail: url,
            full: url
        )
    }

}
