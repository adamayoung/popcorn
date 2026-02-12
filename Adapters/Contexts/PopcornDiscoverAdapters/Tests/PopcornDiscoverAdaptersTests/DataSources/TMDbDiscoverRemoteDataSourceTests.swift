//
//  TMDbDiscoverRemoteDataSourceTests.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import DiscoverInfrastructure
import Foundation
@testable import PopcornDiscoverAdapters
import Testing
import TMDb

// swiftlint:disable:next todo
// TODO: Re-enable these tests once typed throws issue with Swift Testing is resolved
// These tests hang due to interaction between typed throws and Swift Testing
@Suite("TMDbDiscoverRemoteDataSource Tests", .disabled())
struct TMDbDiscoverRemoteDataSourceTests {

    // MARK: - Movies Tests

    @Test("movies maps response and uses en language")
    func movies_mapsResponseAndUsesEnglishLanguage() async throws {
        let mockService = MockDiscoverService()
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)

        let tmdbMovie = MovieListItem(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac...",
            genreIDs: [18, 53],
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 61.416,
            voteAverage: 8.433,
            voteCount: 27044,
            hasVideo: false,
            isAdultOnly: false
        )

        let pageableList = MoviePageableList(
            page: 1,
            results: [tmdbMovie],
            totalResults: 1,
            totalPages: 1
        )

        mockService.moviesStub = .success(pageableList)

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == 550)
        #expect(result[0].title == "Fight Club")
        #expect(mockService.moviesCallCount == 1)
        #expect(mockService.moviesCalledWith[0].page == 1)
        #expect(mockService.moviesCalledWith[0].language == "en")
    }

    @Test("movies with filter passes filter to service")
    func movies_withFilterPassesFilterToService() async throws {
        let mockService = MockDiscoverService()
        let pageableList = MoviePageableList(
            page: 1,
            results: [],
            totalResults: 0,
            totalPages: 1
        )

        mockService.moviesStub = .success(pageableList)

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)
        let filter = MovieFilter(originalLanguage: "fr", genres: [28])

        _ = try await dataSource.movies(filter: filter, page: 2)

        #expect(mockService.moviesCallCount == 1)
        #expect(mockService.moviesCalledWith[0].page == 2)
        #expect(mockService.moviesCalledWith[0].filter?.originalLanguage == "fr")
        #expect(mockService.moviesCalledWith[0].filter?.genres == [28])
    }

    @Test("movies throws unauthorised error for TMDb unauthorised")
    func movies_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let mockService = MockDiscoverService()
        mockService.moviesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        await #expect(throws: DiscoverRemoteDataSourceError.self) {
            try await dataSource.movies(filter: nil, page: 1)
        }
    }

    @Test("movies throws unknown error for non mapped TMDb error")
    func movies_throwsUnknownErrorForNonMappedTMDbError() async {
        let mockService = MockDiscoverService()
        mockService.moviesStub = .failure(.network(TestError()))

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        await #expect(throws: DiscoverRemoteDataSourceError.self) {
            try await dataSource.movies(filter: nil, page: 1)
        }
    }

    @Test("movies returns empty array when service returns no results")
    func movies_returnsEmptyArrayWhenServiceReturnsNoResults() async throws {
        let mockService = MockDiscoverService()
        let pageableList = MoviePageableList(
            page: 1,
            results: [],
            totalResults: 0,
            totalPages: 0
        )

        mockService.moviesStub = .success(pageableList)

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result.isEmpty)
    }

    // MARK: - TV Series Tests

    @Test("tvSeries maps response and uses en language")
    func tvSeries_mapsResponseAndUsesEnglishLanguage() async throws {
        let mockService = MockDiscoverService()
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))
        let firstAirDate = Date(timeIntervalSince1970: 1_200_528_000)

        let tmdbTVSeries = TVSeriesListItem(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            originalLanguage: "en",
            overview: "A high school chemistry teacher...",
            genreIDs: [18, 80],
            firstAirDate: firstAirDate,
            originCountries: ["US"],
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 400.5,
            voteAverage: 9.5,
            voteCount: 15000,
            isAdultOnly: false
        )

        let pageableList = TVSeriesPageableList(
            page: 1,
            results: [tmdbTVSeries],
            totalResults: 1,
            totalPages: 1
        )

        mockService.tvSeriesStub = .success(pageableList)

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        let result = try await dataSource.tvSeries(filter: nil, page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == 1396)
        #expect(result[0].name == "Breaking Bad")
        #expect(mockService.tvSeriesCallCount == 1)
        #expect(mockService.tvSeriesCalledWith[0].page == 1)
        #expect(mockService.tvSeriesCalledWith[0].language == "en")
    }

    @Test("tvSeries with filter passes filter to service")
    func tvSeries_withFilterPassesFilterToService() async throws {
        let mockService = MockDiscoverService()
        let pageableList = TVSeriesPageableList(
            page: 1,
            results: [],
            totalResults: 0,
            totalPages: 1
        )

        mockService.tvSeriesStub = .success(pageableList)

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)
        let filter = TVSeriesFilter(originalLanguage: "ko", genres: [18])

        _ = try await dataSource.tvSeries(filter: filter, page: 3)

        #expect(mockService.tvSeriesCallCount == 1)
        #expect(mockService.tvSeriesCalledWith[0].page == 3)
        #expect(mockService.tvSeriesCalledWith[0].filter?.originalLanguage == "ko")
        #expect(mockService.tvSeriesCalledWith[0].filter?.genres == [18])
    }

    @Test("tvSeries throws unauthorised error for TMDb unauthorised")
    func tvSeries_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let mockService = MockDiscoverService()
        mockService.tvSeriesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        await #expect(throws: DiscoverRemoteDataSourceError.self) {
            try await dataSource.tvSeries(filter: nil, page: 1)
        }
    }

    @Test("tvSeries throws unknown error for non mapped TMDb error")
    func tvSeries_throwsUnknownErrorForNonMappedTMDbError() async {
        let mockService = MockDiscoverService()
        mockService.tvSeriesStub = .failure(.network(TestError()))

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        await #expect(throws: DiscoverRemoteDataSourceError.self) {
            try await dataSource.tvSeries(filter: nil, page: 1)
        }
    }

    @Test("tvSeries returns empty array when service returns no results")
    func tvSeries_returnsEmptyArrayWhenServiceReturnsNoResults() async throws {
        let mockService = MockDiscoverService()
        let pageableList = TVSeriesPageableList(
            page: 1,
            results: [],
            totalResults: 0,
            totalPages: 0
        )

        mockService.tvSeriesStub = .success(pageableList)

        let dataSource = TMDbDiscoverRemoteDataSource(discoverService: mockService)

        let result = try await dataSource.tvSeries(filter: nil, page: 1)

        #expect(result.isEmpty)
    }

}

// MARK: - Test Helpers

private extension TMDbDiscoverRemoteDataSourceTests {

    struct TestError: Error {}

}
