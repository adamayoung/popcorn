//
//  TMDbMediaRemoteDataSourceTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornSearchAdapters
import SearchDomain
import SearchInfrastructure
import Testing
import TMDb

@Suite("TMDbMediaRemoteDataSource Tests")
struct TMDbMediaRemoteDataSourceTests {

    let mockService: MockSearchService

    init() {
        self.mockService = MockSearchService()
    }

    @Test("search maps response and uses en language")
    func searchMapsResponseAndUsesEnglishLanguage() async throws {
        let query = "Inception"
        let page = 1
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let movieListItem = MovieListItem(
            id: 27205,
            title: "Inception",
            originalTitle: "Inception",
            originalLanguage: "en",
            overview: "A mind-bending thriller",
            genreIDs: [28, 878],
            posterPath: posterPath
        )
        let mediaPageableList = MediaPageableList(
            page: 1,
            results: [.movie(movieListItem)],
            totalResults: 1,
            totalPages: 1
        )

        mockService.searchAllStub = .success(mediaPageableList)

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        let results = try await dataSource.search(query: query, page: page)

        #expect(results.count == 1)
        #expect(mockService.searchAllCallCount == 1)
        #expect(mockService.searchAllCalledWith[0].query == query)
        #expect(mockService.searchAllCalledWith[0].page == page)
        #expect(mockService.searchAllCalledWith[0].language == "en")

        guard case .movie(let moviePreview) = results[0] else {
            Issue.record("Expected movie case")
            return
        }
        #expect(moviePreview.id == 27205)
        #expect(moviePreview.title == "Inception")
    }

    @Test("search returns multiple media types")
    func searchReturnsMultipleMediaTypes() async throws {
        let movieListItem = MovieListItem(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie",
            originalLanguage: "en",
            overview: "Movie overview",
            genreIDs: []
        )
        let tvSeriesListItem = TVSeriesListItem(
            id: 2,
            name: "Test TV Series",
            originalName: "Test TV Series",
            originalLanguage: "en",
            overview: "TV series overview",
            genreIDs: [],
            originCountries: []
        )
        let personListItem = PersonListItem(
            id: 3,
            name: "Test Person",
            originalName: "Test Person",
            gender: .male
        )
        let mediaPageableList = MediaPageableList(
            page: 1,
            results: [.movie(movieListItem), .tvSeries(tvSeriesListItem), .person(personListItem)],
            totalResults: 3,
            totalPages: 1
        )

        mockService.searchAllStub = .success(mediaPageableList)

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        let results = try await dataSource.search(query: "test", page: 1)

        #expect(results.count == 3)

        guard case .movie = results[0] else {
            Issue.record("Expected movie at index 0")
            return
        }
        guard case .tvSeries = results[1] else {
            Issue.record("Expected tvSeries at index 1")
            return
        }
        guard case .person = results[2] else {
            Issue.record("Expected person at index 2")
            return
        }
    }

    @Test("search filters out collection media type")
    func searchFiltersOutCollectionMediaType() async throws {
        let movieListItem = MovieListItem(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie",
            originalLanguage: "en",
            overview: "Movie overview",
            genreIDs: []
        )
        let collectionListItem = CollectionListItem(
            id: 2,
            title: "Test Collection",
            originalTitle: "Test Collection Original",
            originalLanguage: "en",
            overview: "A test collection overview",
            posterPath: nil,
            backdropPath: nil
        )
        let mediaPageableList = MediaPageableList(
            page: 1,
            results: [.movie(movieListItem), .collection(collectionListItem)],
            totalResults: 2,
            totalPages: 1
        )

        mockService.searchAllStub = .success(mediaPageableList)

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        let results = try await dataSource.search(query: "test", page: 1)

        #expect(results.count == 1)
        guard case .movie = results[0] else {
            Issue.record("Expected movie at index 0")
            return
        }
    }

    @Test("search returns empty array for no results")
    func searchReturnsEmptyArrayForNoResults() async throws {
        let mediaPageableList = MediaPageableList(
            page: 1,
            results: [],
            totalResults: 0,
            totalPages: 0
        )

        mockService.searchAllStub = .success(mediaPageableList)

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        let results = try await dataSource.search(query: "nonexistent", page: 1)

        #expect(results.isEmpty)
    }

    @Test("search throws unauthorised error for TMDb unauthorised")
    func searchThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.searchAllStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        await #expect(
            performing: {
                try await dataSource.search(query: "test", page: 1)
            },
            throws: { error in
                guard let error = error as? MediaRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("search throws unknown error for TMDb network error")
    func searchThrowsUnknownErrorForTMDbNetworkError() async {
        mockService.searchAllStub = .failure(.network(TestError()))

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        await #expect(
            performing: {
                try await dataSource.search(query: "test", page: 1)
            },
            throws: { error in
                guard let error = error as? MediaRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("search throws unknown error for TMDb notFound error")
    func searchThrowsUnknownErrorForTMDbNotFoundError() async {
        mockService.searchAllStub = .failure(.notFound())

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        await #expect(
            performing: {
                try await dataSource.search(query: "test", page: 1)
            },
            throws: { error in
                guard let error = error as? MediaRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("search throws unknown error for TMDb unknown error")
    func searchThrowsUnknownErrorForTMDbUnknownError() async {
        mockService.searchAllStub = .failure(.unknown)

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        await #expect(
            performing: {
                try await dataSource.search(query: "test", page: 1)
            },
            throws: { error in
                guard let error = error as? MediaRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("search passes correct page parameter")
    func searchPassesCorrectPageParameter() async throws {
        let mediaPageableList = MediaPageableList(
            page: 5,
            results: [],
            totalResults: 100,
            totalPages: 10
        )

        mockService.searchAllStub = .success(mediaPageableList)

        let dataSource = TMDbMediaRemoteDataSource(searchService: mockService)

        _ = try await dataSource.search(query: "test", page: 5)

        #expect(mockService.searchAllCalledWith[0].page == 5)
    }

}

private extension TMDbMediaRemoteDataSourceTests {

    struct TestError: Error {}

}
