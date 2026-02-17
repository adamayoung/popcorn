//
//  TVSeriesProviderAdapterTests.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import IntelligenceDomain
@testable import PopcornIntelligenceAdapters
import Testing
import TVSeriesApplication

@Suite("TVSeriesProviderAdapter Tests")
struct TVSeriesProviderAdapterTests {

    @Test("Returns mapped TV series when use case succeeds")
    func returnsMappedTVSeriesWhenUseCaseSucceeds() async throws {
        let posterURLSet = try makeImageURLSet(path: "poster.jpg")
        let backdropURLSet = try makeImageURLSet(path: "backdrop.jpg")

        let tvSeriesDetails = TVSeriesDetails(
            id: 1396,
            name: "Breaking Bad",
            tagline: "All Hail the King",
            overview: "A high school chemistry teacher...",
            numberOfSeasons: 5,
            firstAirDate: Date(timeIntervalSince1970: 1_200_614_400),
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )

        let mockUseCase = MockFetchTVSeriesDetailsUseCase()
        mockUseCase.result = .success(tvSeriesDetails)

        let adapter = TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: mockUseCase)

        let result = try await adapter.tvSeries(withID: 1396)

        #expect(mockUseCase.executeCalledWithID == 1396)
        #expect(result.id == 1396)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == "All Hail the King")
        #expect(result.overview == "A high school chemistry teacher...")
        #expect(result.numberOfSeasons == 5)
        #expect(result.posterPath == posterURLSet.path)
        #expect(result.backdropPath == backdropURLSet.path)
    }

    @Test("Throws notFound error when use case throws notFound")
    func throwsNotFoundErrorWhenUseCaseThrowsNotFound() async throws {
        let mockUseCase = MockFetchTVSeriesDetailsUseCase()
        mockUseCase.result = .failure(.notFound)

        let adapter = TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: mockUseCase)

        var thrownError: TVSeriesProviderError?
        do {
            _ = try await adapter.tvSeries(withID: 999)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithID == 999)
        let error = try #require(thrownError)
        guard case .notFound = error else {
            Issue.record("Expected notFound error but got \(error)")
            return
        }
    }

    @Test("Throws unauthorised error when use case throws unauthorised")
    func throwsUnauthorisedErrorWhenUseCaseThrowsUnauthorised() async throws {
        let mockUseCase = MockFetchTVSeriesDetailsUseCase()
        mockUseCase.result = .failure(.unauthorised)

        let adapter = TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: mockUseCase)

        var thrownError: TVSeriesProviderError?
        do {
            _ = try await adapter.tvSeries(withID: 1396)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithID == 1396)
        let error = try #require(thrownError)
        guard case .unauthorised = error else {
            Issue.record("Expected unauthorised error but got \(error)")
            return
        }
    }

    @Test("Throws unknown error when use case throws unknown")
    func throwsUnknownErrorWhenUseCaseThrowsUnknown() async throws {
        let mockUseCase = MockFetchTVSeriesDetailsUseCase()
        mockUseCase.result = .failure(.unknown(TestError.generic))

        let adapter = TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: mockUseCase)

        var thrownError: TVSeriesProviderError?
        do {
            _ = try await adapter.tvSeries(withID: 1396)
        } catch {
            thrownError = error
        }

        #expect(mockUseCase.executeCalledWithID == 1396)
        let error = try #require(thrownError)
        guard case .unknown = error else {
            Issue.record("Expected unknown error but got \(error)")
            return
        }
    }

    @Test("Passes correct TV series ID to use case")
    func passesCorrectTVSeriesIDToUseCase() async throws {
        let tvSeriesDetails = TVSeriesDetails(
            id: 12345,
            name: "Test Series",
            overview: "Test overview",
            numberOfSeasons: 3
        )

        let mockUseCase = MockFetchTVSeriesDetailsUseCase()
        mockUseCase.result = .success(tvSeriesDetails)

        let adapter = TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: mockUseCase)

        _ = try await adapter.tvSeries(withID: 12345)

        #expect(mockUseCase.executeCalledWithID == 12345)
    }

    @Test("Maps TV series with nil optional fields correctly")
    func mapsTVSeriesWithNilOptionalFieldsCorrectly() async throws {
        let tvSeriesDetails = TVSeriesDetails(
            id: 1396,
            name: "Breaking Bad",
            tagline: nil,
            overview: "An overview",
            numberOfSeasons: 5,
            firstAirDate: nil,
            posterURLSet: nil,
            backdropURLSet: nil
        )

        let mockUseCase = MockFetchTVSeriesDetailsUseCase()
        mockUseCase.result = .success(tvSeriesDetails)

        let adapter = TVSeriesProviderAdapter(fetchTVSeriesDetailsUseCase: mockUseCase)

        let result = try await adapter.tvSeries(withID: 1396)

        #expect(result.tagline == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

}

// MARK: - Test Helpers

extension TVSeriesProviderAdapterTests {

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
