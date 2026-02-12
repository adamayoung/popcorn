//
//  TMDbTrendingRemoteDataSourceTVSeriesTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TMDb
import TrendingDomain
import TrendingInfrastructure

@Suite("TMDbTrendingRemoteDataSource TVSeries Tests")
struct TMDbTrendingRemoteDataSourceTVSeriesTests {

    let mockService: MockTrendingService

    init() {
        self.mockService = MockTrendingService()
    }

    @Test("tvSeries maps response and uses day time window with en language")
    func tvSeries_mapsResponseAndUsesDayTimeWindowWithEnLanguage() async throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))

        let tmdbTVSeries = [
            TVSeriesListItem(
                id: 1399,
                name: "Game of Thrones",
                originalName: "Game of Thrones",
                originalLanguage: "en",
                overview: "Seven noble families fight for control.",
                genreIDs: [10765, 18],
                firstAirDate: Date(timeIntervalSince1970: 1_303_171_200),
                originCountries: ["US"],
                posterPath: posterPath,
                backdropPath: backdropPath,
                popularity: 369.594,
                voteAverage: 8.4,
                voteCount: 21755,
                isAdultOnly: false
            )
        ]

        mockService.tvSeriesStub = .success(
            TVSeriesPageableList(
                page: 1,
                results: tmdbTVSeries,
                totalResults: 1,
                totalPages: 1
            )
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.tvSeries(page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == 1399)
        #expect(result[0].name == "Game of Thrones")
        #expect(result[0].overview == "Seven noble families fight for control.")
        #expect(result[0].posterPath == posterPath)
        #expect(result[0].backdropPath == backdropPath)
        #expect(mockService.tvSeriesCallCount == 1)
        #expect(mockService.tvSeriesCalledWith[0].timeWindow == .day)
        #expect(mockService.tvSeriesCalledWith[0].page == 1)
        #expect(mockService.tvSeriesCalledWith[0].language == "en")
    }

    @Test("tvSeries returns empty array when no results")
    func tvSeries_returnsEmptyArrayWhenNoResults() async throws {
        mockService.tvSeriesStub = .success(
            TVSeriesPageableList(
                page: 1,
                results: [],
                totalResults: 0,
                totalPages: 0
            )
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.tvSeries(page: 1)

        #expect(result.isEmpty)
    }

    @Test("tvSeries throws unauthorised error for TMDb unauthorised")
    func tvSeries_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.tvSeriesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(page: 1)
            },
            throws: { error in
                guard let error = error as? TrendingRepositoryError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeries throws unknown error for non mapped TMDb error")
    func tvSeries_throwsUnknownErrorForNonMappedTMDbError() async {
        mockService.tvSeriesStub = .failure(.network(TestError()))

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeries(page: 1)
            },
            throws: { error in
                guard let error = error as? TrendingRepositoryError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeries passes correct page number")
    func tvSeries_passesCorrectPageNumber() async throws {
        mockService.tvSeriesStub = .success(
            TVSeriesPageableList(page: 5, results: [], totalResults: 200, totalPages: 10)
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        _ = try await dataSource.tvSeries(page: 5)

        #expect(mockService.tvSeriesCalledWith[0].page == 5)
    }

}

// MARK: - Test Helpers

private extension TMDbTrendingRemoteDataSourceTVSeriesTests {

    struct TestError: Error {}

}
