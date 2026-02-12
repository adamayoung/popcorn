//
//  TMDbTVSeriesRemoteDataSourceTVSeriesTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb
import TVSeriesDomain
import TVSeriesInfrastructure

@Suite("TMDbTVSeriesRemoteDataSource tvSeries Tests")
struct TMDbTVSeriesRemoteDataSourceTVSeriesTests {

    let mockService: MockTVSeriesService

    init() {
        self.mockService = MockTVSeriesService()
    }

    // MARK: - tvSeries Tests (Breaking Bad ID: 1396)

    @Test("tvSeries maps response and uses en language using Breaking Bad")
    func tvSeriesMapsResponseAndUsesEnglishLanguageUsingBreakingBad() async throws {
        let id = 1396
        let posterPath = try #require(URL(string: "/3xnWaLQjelJDDF7LT1WBo6f4BRe.jpg"))
        let backdropPath = try #require(URL(string: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg"))
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000) // 2008-01-20

        let tmdbTVSeries = TMDb.TVSeries(
            id: id,
            name: "Breaking Bad",
            tagline: "All Hail the King",
            overview: "When Walter White, a chemistry teacher, is diagnosed with terminal cancer...",
            numberOfSeasons: 5,
            firstAirDate: firstAirDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        mockService.detailsStub = .success(tmdbTVSeries)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.tvSeries(withID: id)

        #expect(result.id == id)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == "All Hail the King")
        #expect(
            result.overview == "When Walter White, a chemistry teacher, is diagnosed with terminal cancer..."
        )
        #expect(result.numberOfSeasons == 5)
        #expect(result.firstAirDate == firstAirDate)
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0] == .init(id: id, language: "en"))
    }

    @Test("tvSeries maps all optional fields correctly")
    func tvSeriesMapsAllOptionalFieldsCorrectly() async throws {
        let id = 1396
        let tmdbTVSeries = TMDb.TVSeries(
            id: id,
            name: "Breaking Bad",
            tagline: nil,
            overview: nil,
            numberOfSeasons: nil,
            firstAirDate: nil,
            posterPath: nil,
            backdropPath: nil
        )

        mockService.detailsStub = .success(tmdbTVSeries)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        let result = try await dataSource.tvSeries(withID: id)

        #expect(result.id == id)
        #expect(result.name == "Breaking Bad")
        #expect(result.tagline == nil)
        #expect(result.overview == "")
        #expect(result.numberOfSeasons == 0)
        #expect(result.firstAirDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    @Test("tvSeries throws notFound error for TMDb notFound")
    func tvSeriesThrowsNotFoundErrorForTMDbNotFound() async {
        let id = 1396

        mockService.detailsStub = .failure(.notFound())

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(withID: id)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeries throws unauthorised error for TMDb unauthorised")
    func tvSeriesThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        let id = 1396

        mockService.detailsStub = .failure(.unauthorised("Invalid API key"))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(withID: id)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeries throws unknown error for network TMDb error")
    func tvSeriesThrowsUnknownErrorForNetworkTMDbError() async {
        let id = 1396

        mockService.detailsStub = .failure(.network(TestError()))

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(withID: id)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeries throws unknown error for unknown TMDb error")
    func tvSeriesThrowsUnknownErrorForUnknownTMDbError() async {
        let id = 1396

        mockService.detailsStub = .failure(.unknown)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(withID: id)
            },
            throws: { error in
                guard let error = error as? TVSeriesRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeries calls service with correct id")
    func tvSeriesCallsServiceWithCorrectId() async throws {
        let id = 1396
        let tmdbTVSeries = TMDb.TVSeries(
            id: id,
            name: "Breaking Bad",
            overview: "A chemistry teacher..."
        )

        mockService.detailsStub = .success(tmdbTVSeries)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        _ = try await dataSource.tvSeries(withID: id)

        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0].id == id)
    }

    @Test("tvSeries calls service with en language")
    func tvSeriesCallsServiceWithEnLanguage() async throws {
        let id = 1396
        let tmdbTVSeries = TMDb.TVSeries(
            id: id,
            name: "Breaking Bad",
            overview: "A chemistry teacher..."
        )

        mockService.detailsStub = .success(tmdbTVSeries)

        let dataSource = TMDbTVSeriesRemoteDataSource(tvSeriesService: mockService)

        _ = try await dataSource.tvSeries(withID: id)

        #expect(mockService.detailsCalledWith[0].language == "en")
    }

}

// MARK: - Test Helpers

private extension TMDbTVSeriesRemoteDataSourceTVSeriesTests {

    struct TestError: Error {}

}
