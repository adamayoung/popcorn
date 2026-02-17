//
//  TMDbTrendingRemoteDataSourceMoviesTests.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornTrendingAdapters
import Testing
import TMDb
import TrendingDomain
import TrendingInfrastructure

@Suite("TMDbTrendingRemoteDataSource Movies Tests")
struct TMDbTrendingRemoteDataSourceMoviesTests {

    let mockService: MockTrendingService

    init() {
        self.mockService = MockTrendingService()
    }

    @Test("movies maps response and uses day time window with en language")
    func movies_mapsResponseAndUsesDayTimeWindowWithEnLanguage() async throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))

        let tmdbMovies = [
            MovieListItem(
                id: 550,
                title: "Fight Club",
                originalTitle: "Fight Club",
                originalLanguage: "en",
                overview: "A ticking-time-bomb insomniac.",
                genreIDs: [18],
                releaseDate: Date(timeIntervalSince1970: 939_686_400),
                posterPath: posterPath,
                backdropPath: backdropPath,
                popularity: 61.416,
                voteAverage: 8.433,
                voteCount: 27044,
                hasVideo: false,
                isAdultOnly: false
            )
        ]

        mockService.moviesStub = .success(
            MoviePageableList(
                page: 1,
                results: tmdbMovies,
                totalResults: 1,
                totalPages: 1
            )
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.movies(page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == 550)
        #expect(result[0].title == "Fight Club")
        #expect(result[0].overview == "A ticking-time-bomb insomniac.")
        #expect(result[0].posterPath == posterPath)
        #expect(result[0].backdropPath == backdropPath)
        #expect(mockService.moviesCallCount == 1)
        #expect(mockService.moviesCalledWith[0].timeWindow == .day)
        #expect(mockService.moviesCalledWith[0].page == 1)
        #expect(mockService.moviesCalledWith[0].language == "en")
    }

    @Test("movies returns empty array when no results")
    func movies_returnsEmptyArrayWhenNoResults() async throws {
        mockService.moviesStub = .success(
            MoviePageableList(
                page: 1,
                results: [],
                totalResults: 0,
                totalPages: 0
            )
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.movies(page: 1)

        #expect(result.isEmpty)
    }

    @Test("movies throws unauthorised error for TMDb unauthorised")
    func movies_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.moviesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        await #expect(
            performing: {
                try await dataSource.movies(page: 1)
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

    @Test("movies throws unknown error for non mapped TMDb error")
    func movies_throwsUnknownErrorForNonMappedTMDbError() async {
        mockService.moviesStub = .failure(.network(TestError()))

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        await #expect(
            performing: {
                try await dataSource.movies(page: 1)
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

    @Test("movies passes correct page number")
    func movies_passesCorrectPageNumber() async throws {
        mockService.moviesStub = .success(
            MoviePageableList(page: 3, results: [], totalResults: 100, totalPages: 5)
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        _ = try await dataSource.movies(page: 3)

        #expect(mockService.moviesCalledWith[0].page == 3)
    }

    @Test("movies maps multiple results correctly")
    func movies_mapsMultipleResultsCorrectly() async throws {
        let tmdbMovies = [
            MovieListItem(
                id: 1,
                title: "Movie 1",
                originalTitle: "Movie 1",
                originalLanguage: "en",
                overview: "Overview 1",
                genreIDs: [],
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil
            ),
            MovieListItem(
                id: 2,
                title: "Movie 2",
                originalTitle: "Movie 2",
                originalLanguage: "en",
                overview: "Overview 2",
                genreIDs: [],
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil
            ),
            MovieListItem(
                id: 3,
                title: "Movie 3",
                originalTitle: "Movie 3",
                originalLanguage: "en",
                overview: "Overview 3",
                genreIDs: [],
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil
            )
        ]

        mockService.moviesStub = .success(
            MoviePageableList(page: 1, results: tmdbMovies, totalResults: 3, totalPages: 1)
        )

        let dataSource = TMDbTrendingRemoteDataSource(trendingService: mockService)

        let result = try await dataSource.movies(page: 1)

        #expect(result.count == 3)
        #expect(result[0].id == 1)
        #expect(result[1].id == 2)
        #expect(result[2].id == 3)
    }

}

// MARK: - Test Helpers

private extension TMDbTrendingRemoteDataSourceMoviesTests {

    struct TestError: Error {}

}
