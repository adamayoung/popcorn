//
//  TVSeriesLogoImageProviderAdapterTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation
@testable import PopcornDiscoverAdapters
import Testing
import TVSeriesApplication

@Suite("TVSeriesLogoImageProviderAdapter Tests")
struct TVSeriesLogoImageProviderAdapterTests {

    let mockUseCase: MockFetchTVSeriesImageCollectionUseCase

    init() {
        self.mockUseCase = MockFetchTVSeriesImageCollectionUseCase()
    }

    @Test("imageURLSet returns first logo from use case")
    func imageURLSet_returnsFirstLogoFromUseCase() async throws {
        let tvSeriesID = 1396
        let logoURLSet = try makeImageURLSet(path: "https://example.com/logo1.png")
        let secondLogoURLSet = try makeImageURLSet(path: "https://example.com/logo2.png")

        let imageCollection = ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [],
            backdropURLSets: [],
            logoURLSets: [logoURLSet, secondLogoURLSet]
        )

        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        let result = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(mockUseCase.executeCallCount == 1)
        #expect(mockUseCase.executeCalledWith[0] == tvSeriesID)
        #expect(result == logoURLSet)
    }

    @Test("imageURLSet returns nil when no logos available")
    func imageURLSet_returnsNilWhenNoLogosAvailable() async throws {
        let tvSeriesID = 1396

        let imageCollection = try ImageCollectionDetails(
            id: tvSeriesID,
            posterURLSets: [makeImageURLSet(path: "https://example.com/poster.jpg")],
            backdropURLSets: [makeImageURLSet(path: "https://example.com/backdrop.jpg")],
            logoURLSets: []
        )

        mockUseCase.executeStub = .success(imageCollection)

        let adapter = TVSeriesLogoImageProviderAdapter(
            fetchTVSeriesImageCollectionUseCase: mockUseCase
        )

        let result = try await adapter.imageURLSet(forTVSeries: tvSeriesID)

        #expect(result == nil)
    }

    @Test("imageURLSet throws notFound error from use case")
    func imageURLSet_throwsNotFoundErrorFromUseCase() async {
        let tvSeriesID = 999

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

    @Test("imageURLSet throws unauthorised error from use case")
    func imageURLSet_throwsUnauthorisedErrorFromUseCase() async {
        let tvSeriesID = 1396

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

    @Test("imageURLSet throws unknown error from use case for unknown error")
    func imageURLSet_throwsUnknownErrorFromUseCaseForUnknownError() async {
        let tvSeriesID = 1396

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

}

// MARK: - Test Helpers

private extension TVSeriesLogoImageProviderAdapterTests {

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
