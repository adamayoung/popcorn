//
//  DefaultTrendingRepositoryMoviesTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TrendingDomain
@testable import TrendingInfrastructure

@Suite("DefaultTrendingRepository Movies")
struct DefaultTrendingRepositoryMoviesTests {

    let mockRemoteDataSource: MockTrendingRemoteDataSource

    init() {
        self.mockRemoteDataSource = MockTrendingRemoteDataSource()
    }

    @Test("movies returns page from remote data source")
    func moviesReturnsPageFromRemoteDataSource() async throws {
        let page = MoviePreviewPage.mock(page: 1, totalPages: 4, movies: MoviePreview.mocks)
        mockRemoteDataSource.moviesStub = .success(page)

        let repository = makeRepository()

        let result = try await repository.movies(page: 1)

        #expect(result == page)
    }

    @Test("movies passes through pagination metadata from remote data source")
    func moviesPassesThroughPaginationMetadata() async throws {
        mockRemoteDataSource.moviesStub = .success(.mock(page: 2, totalPages: 8, movies: []))

        let repository = makeRepository()

        let result = try await repository.movies(page: 2)

        #expect(result.page == 2)
        #expect(result.totalPages == 8)
    }

    @Test("movies passes page to remote data source")
    func moviesPassesPageToRemoteDataSource() async throws {
        mockRemoteDataSource.moviesStub = .success(.mock(movies: []))

        let repository = makeRepository()

        _ = try await repository.movies(page: 3)

        #expect(mockRemoteDataSource.moviesCallCount == 1)
        #expect(mockRemoteDataSource.moviesCalledWith == [3])
    }

    @Test("movies returns empty movies when remote returns empty")
    func moviesReturnsEmptyMoviesWhenRemoteReturnsEmpty() async throws {
        mockRemoteDataSource.moviesStub = .success(.mock(movies: []))

        let repository = makeRepository()

        let result = try await repository.movies(page: 1)

        #expect(result.movies.isEmpty)
    }

    @Test("movies throws unauthorised error when remote throws unauthorised")
    func moviesThrowsUnauthorisedErrorWhenRemoteThrowsUnauthorised() async {
        mockRemoteDataSource.moviesStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movies(page: 1)
            },
            throws: { error in
                guard let repositoryError = error as? TrendingRepositoryError else {
                    return false
                }
                if case .unauthorised = repositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("movies throws unknown error when remote throws unknown")
    func moviesThrowsUnknownErrorWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRemoteDataSource.moviesStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movies(page: 1)
            },
            throws: { error in
                guard let repositoryError = error as? TrendingRepositoryError else {
                    return false
                }
                if case .unknown = repositoryError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultTrendingRepository {
        DefaultTrendingRepository(remoteDataSource: mockRemoteDataSource)
    }

}
