//
//  TMDbMovieRemoteDataSourceListsTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
@testable import PopcornMoviesAdapters
import Testing
import TMDb

// swiftlint:disable:next todo
// TODO: Re-enable these tests once typed throws issue with Swift Testing is resolved.
// The TMDbMovieRemoteDataSource uses typed throws (throws(MovieRemoteDataSourceError)) which
// causes Swift Testing to hang on async methods. See: https://github.com/swiftlang/swift-testing/issues/777

@Suite("TMDbMovieRemoteDataSource Lists Tests", .disabled("Typed throws causes Swift Testing to hang"))
struct TMDbMovieRemoteDataSourceListsTests {

    let mockService: MockMoviesService

    init() {
        self.mockService = MockMoviesService()
    }

    // MARK: - popular(page:) Tests

    @Test("popular maps response correctly")
    func popular_mapsResponseCorrectly() async throws {
        let page = 1
        let posterPath = try #require(URL(string: "/poster.jpg"))

        let tmdbMovieList = MoviePageableList(
            page: page,
            results: [
                MovieListItem(
                    id: 550,
                    title: "Fight Club",
                    originalTitle: "Fight Club",
                    originalLanguage: "en",
                    overview: "Overview",
                    genreIDs: [],
                    releaseDate: nil,
                    posterPath: posterPath,
                    backdropPath: nil,
                    popularity: 61.4,
                    voteAverage: 8.4,
                    voteCount: 27044,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )

        mockService.popularStub = .success(tmdbMovieList)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.popular(page: page)

        #expect(result.count == 1)
        #expect(result[0].id == 550)
        #expect(result[0].title == "Fight Club")
        #expect(mockService.popularCallCount == 1)
        #expect(mockService.popularCalledWith[0].page == page)
    }

    @Test("popular throws notFound error for TMDb notFound")
    func popular_throwsNotFoundErrorForTMDbNotFound() async {
        mockService.popularStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.popular(page: 1)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("popular throws unauthorised error for TMDb unauthorised")
    func popular_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.popularStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.popular(page: 1)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    // MARK: - similar(toMovie:page:) Tests

    @Test("similar maps response correctly")
    func similar_mapsResponseCorrectly() async throws {
        let movieID = 550
        let page = 1

        let tmdbMovieList = MoviePageableList(
            page: page,
            results: [
                MovieListItem(
                    id: 551,
                    title: "Se7en",
                    originalTitle: "Se7en",
                    originalLanguage: "en",
                    overview: "Overview",
                    genreIDs: [],
                    releaseDate: nil,
                    posterPath: nil,
                    backdropPath: nil,
                    popularity: 50.0,
                    voteAverage: 8.3,
                    voteCount: 15000,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )

        mockService.similarStub = .success(tmdbMovieList)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.similar(toMovie: movieID, page: page)

        #expect(result.count == 1)
        #expect(result[0].id == 551)
        #expect(result[0].title == "Se7en")
        #expect(mockService.similarCallCount == 1)
        #expect(mockService.similarCalledWith[0].movieID == movieID)
        #expect(mockService.similarCalledWith[0].page == page)
    }

    @Test("similar throws notFound error for TMDb notFound")
    func similar_throwsNotFoundErrorForTMDbNotFound() async {
        mockService.similarStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.similar(toMovie: 550, page: 1)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("similar throws unauthorised error for TMDb unauthorised")
    func similar_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.similarStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.similar(toMovie: 550, page: 1)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    // MARK: - recommendations(forMovie:page:) Tests

    @Test("recommendations maps response correctly")
    func recommendations_mapsResponseCorrectly() async throws {
        let movieID = 550
        let page = 1

        let tmdbMovieList = MoviePageableList(
            page: page,
            results: [
                MovieListItem(
                    id: 552,
                    title: "The Social Network",
                    originalTitle: "The Social Network",
                    originalLanguage: "en",
                    overview: "Overview",
                    genreIDs: [],
                    releaseDate: nil,
                    posterPath: nil,
                    backdropPath: nil,
                    popularity: 40.0,
                    voteAverage: 7.3,
                    voteCount: 10000,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )

        mockService.recommendationsStub = .success(tmdbMovieList)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.recommendations(forMovie: movieID, page: page)

        #expect(result.count == 1)
        #expect(result[0].id == 552)
        #expect(result[0].title == "The Social Network")
        #expect(mockService.recommendationsCallCount == 1)
        #expect(mockService.recommendationsCalledWith[0].movieID == movieID)
        #expect(mockService.recommendationsCalledWith[0].page == page)
    }

    @Test("recommendations throws notFound error for TMDb notFound")
    func recommendations_throwsNotFoundErrorForTMDbNotFound() async {
        mockService.recommendationsStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.recommendations(forMovie: 550, page: 1)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("recommendations throws unauthorised error for TMDb unauthorised")
    func recommendations_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.recommendationsStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.recommendations(forMovie: 550, page: 1)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

}
