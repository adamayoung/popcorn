//
//  TVSeriesLogoImageProviderAdapterTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TrendingDomain
import TVSeriesApplication

@Suite("TVSeriesLogoImageProviderAdapter Tests")
struct TVSeriesLogoImageProviderAdapterTests {

    let mockUseCase: MockFetchTVSeriesImageCollectionUseCase

    init() {
        self.mockUseCase = MockFetchTVSeriesImageCollectionUseCase()
    }

    @Test("imageURLSet returns first logo URL set when available")
    func imageURLSet_returnsFirstLogoURLSetWhenAvailable() async throws {
        let tvSeriesID = 1399
        let logoURLSet = try makeImageURLSet(path: "https://example.com/logo.png")
        let imageCollection = ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: [logoURLSet]
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        let result = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(result == logoURLSet)
        #expect(mockUseCase.executeCallCount == 1)
        #expect(mockUseCase.executeCalledWith[0] == tvSeriesID)
    }

    @Test("imageURLSet returns nil when no logo URL sets available")
    func imageURLSet_returnsNilWhenNoLogoURLSetsAvailable() async throws {
        let tvSeriesID = 1399
        let imageCollection = ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: []
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        let result = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(result == nil)
    }

    @Test("imageURLSet returns first logo URL set when multiple available")
    func imageURLSet_returnsFirstLogoURLSetWhenMultipleAvailable() async throws {
        let tvSeriesID = 1399
        let firstLogoURLSet = try makeImageURLSet(path: "https://example.com/logo1.png")
        let secondLogoURLSet = try makeImageURLSet(path: "https://example.com/logo2.png")
        let imageCollection = ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: [firstLogoURLSet, secondLogoURLSet]
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        let result = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(result == firstLogoURLSet)
    }

    @Test("imageURLSet throws notFound error when use case throws notFound")
    func imageURLSet_throwsNotFoundErrorWhenUseCaseThrowsNotFound() async {
        let tvSeriesID = 1399
        mockUseCase.executeStub = .failure(.notFound)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        await #expect(
            performing: {
                try await adapter.imageURLSet(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesLogoImageProviderError else {
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
        let tvSeriesID = 1399
        mockUseCase.executeStub = .failure(.unauthorised)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        await #expect(
            performing: {
                try await adapter.imageURLSet(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesLogoImageProviderError else {
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
        let tvSeriesID = 1399
        mockUseCase.executeStub = .failure(.unknown(TestError()))

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        await #expect(
            performing: {
                try await adapter.imageURLSet(forTVSeries: tvSeriesID)
            },
            throws: { error in
                guard let error = error as? TVSeriesLogoImageProviderError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("imageURLSet passes correct TV series ID to use case")
    func imageURLSet_passesCorrectTVSeriesIDToUseCase() async throws {
        let tvSeriesID = 98765
        let imageCollection = ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: []
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        _ = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(mockUseCase.executeCalledWith[0] == tvSeriesID)
    }

    @Test("imageURLSet ignores poster and backdrop URL sets")
    func imageURLSet_ignoresPosterAndBackdropURLSets() async throws {
        let tvSeriesID = 1399
        let posterURLSet = try makeImageURLSet(path: "https://example.com/poster.jpg")
        let backdropURLSet = try makeImageURLSet(path: "https://example.com/backdrop.jpg")
        let imageCollection = ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [posterURLSet],
            backdropURLSets: [backdropURLSet],
            logoURLSets: []
        )
        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        let result = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(result == nil)
    }

}

// MARK: - Test Helpers

private extension TVSeriesLogoImageProviderAdapterTests {

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
