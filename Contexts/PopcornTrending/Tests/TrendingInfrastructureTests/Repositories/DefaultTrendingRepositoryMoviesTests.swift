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

    @Test("movies returns values from remote data source")
    func moviesReturnsValuesFromRemoteDataSource() async throws {
        let moviePreviews = MoviePreview.mocks
        mockRemoteDataSource.moviesStub = .success(moviePreviews)

        let repository = makeRepository()

        let result = try await repository.movies(page: 1)

        #expect(result == moviePreviews)
    }

    @Test("movies passes page to remote data source")
    func moviesPassesPageToRemoteDataSource() async throws {
        mockRemoteDataSource.moviesStub = .success([])

        let repository = makeRepository()

        _ = try await repository.movies(page: 3)

        #expect(mockRemoteDataSource.moviesCallCount == 1)
        #expect(mockRemoteDataSource.moviesCalledWith == [3])
    }

    @Test("movies returns empty array when remote returns empty")
    func moviesReturnsEmptyArrayWhenRemoteReturnsEmpty() async throws {
        mockRemoteDataSource.moviesStub = .success([])

        let repository = makeRepository()

        let result = try await repository.movies(page: 1)

        #expect(result.isEmpty)
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
