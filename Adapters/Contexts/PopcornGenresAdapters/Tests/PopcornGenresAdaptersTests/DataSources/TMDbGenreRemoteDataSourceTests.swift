//
//  TMDbGenreRemoteDataSourceTests.swift
//  PopcornGenresAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain
import GenresInfrastructure
@testable import PopcornGenresAdapters
import Testing
import TMDb

@Suite("TMDbGenreRemoteDataSource Tests")
struct TMDbGenreRemoteDataSourceTests {

    let mockService: MockGenresService

    init() {
        self.mockService = MockGenresService()
    }

    // MARK: - movieGenres Tests

    @Test("movieGenres returns mapped genres")
    func movieGenresReturnsMappedGenres() async throws {
        let tmdbGenres = [
            TMDb.Genre(id: 28, name: "Action"),
            TMDb.Genre(id: 12, name: "Adventure"),
            TMDb.Genre(id: 16, name: "Animation")
        ]
        mockService.movieGenresStub = .success(tmdbGenres)

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        let result = try await dataSource.movieGenres()

        #expect(result.count == 3)
        #expect(result[0].id == 28)
        #expect(result[0].name == "Action")
        #expect(result[1].id == 12)
        #expect(result[1].name == "Adventure")
        #expect(result[2].id == 16)
        #expect(result[2].name == "Animation")
    }

    @Test("movieGenres calls service with en language")
    func movieGenresCallsServiceWithEnLanguage() async throws {
        mockService.movieGenresStub = .success([])

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        _ = try await dataSource.movieGenres()

        #expect(mockService.movieGenresCallCount == 1)
        #expect(mockService.movieGenresCalledWith[0].language == "en")
    }

    @Test("movieGenres returns empty array when service returns empty")
    func movieGenresReturnsEmptyArrayWhenServiceReturnsEmpty() async throws {
        mockService.movieGenresStub = .success([])

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        let result = try await dataSource.movieGenres()

        #expect(result.isEmpty)
    }

    @Test("movieGenres throws unauthorised error for TMDb unauthorised")
    func movieGenresThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.movieGenresStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        await #expect(
            performing: {
                try await dataSource.movieGenres()
            },
            throws: { error in
                guard let error = error as? GenreRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("movieGenres throws unknown error for non-mapped TMDb error")
    func movieGenresThrowsUnknownErrorForNonMappedTMDbError() async {
        mockService.movieGenresStub = .failure(.network(TestError()))

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        await #expect(
            performing: {
                try await dataSource.movieGenres()
            },
            throws: { error in
                guard let error = error as? GenreRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

    // MARK: - tvSeriesGenres Tests

    @Test("tvSeriesGenres returns mapped genres")
    func tvSeriesGenresReturnsMappedGenres() async throws {
        let tmdbGenres = [
            TMDb.Genre(id: 10759, name: "Action & Adventure"),
            TMDb.Genre(id: 35, name: "Comedy"),
            TMDb.Genre(id: 18, name: "Drama")
        ]
        mockService.tvSeriesGenresStub = .success(tmdbGenres)

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        let result = try await dataSource.tvSeriesGenres()

        #expect(result.count == 3)
        #expect(result[0].id == 10759)
        #expect(result[0].name == "Action & Adventure")
        #expect(result[1].id == 35)
        #expect(result[1].name == "Comedy")
        #expect(result[2].id == 18)
        #expect(result[2].name == "Drama")
    }

    @Test("tvSeriesGenres calls service with en language")
    func tvSeriesGenresCallsServiceWithEnLanguage() async throws {
        mockService.tvSeriesGenresStub = .success([])

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        _ = try await dataSource.tvSeriesGenres()

        #expect(mockService.tvSeriesGenresCallCount == 1)
        #expect(mockService.tvSeriesGenresCalledWith[0].language == "en")
    }

    @Test("tvSeriesGenres returns empty array when service returns empty")
    func tvSeriesGenresReturnsEmptyArrayWhenServiceReturnsEmpty() async throws {
        mockService.tvSeriesGenresStub = .success([])

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        let result = try await dataSource.tvSeriesGenres()

        #expect(result.isEmpty)
    }

    @Test("tvSeriesGenres throws unauthorised error for TMDb unauthorised")
    func tvSeriesGenresThrowsUnauthorisedErrorForTMDbUnauthorised() async {
        mockService.tvSeriesGenresStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeriesGenres()
            },
            throws: { error in
                guard let error = error as? GenreRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("tvSeriesGenres throws unknown error for non-mapped TMDb error")
    func tvSeriesGenresThrowsUnknownErrorForNonMappedTMDbError() async {
        mockService.tvSeriesGenresStub = .failure(.network(TestError()))

        let dataSource = TMDbGenreRemoteDataSource(genreService: mockService)

        await #expect(
            performing: {
                try await dataSource.tvSeriesGenres()
            },
            throws: { error in
                guard let error = error as? GenreRemoteDataSourceError else {
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

private extension TMDbGenreRemoteDataSourceTests {

    struct TestError: Error {}

}
