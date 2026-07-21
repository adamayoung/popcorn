//
//  DefaultPopularMovieRepositoryTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import Testing

@Suite("DefaultPopularMovieRepository")
struct DefaultPopularMovieRepositoryTests {

    let mockRemoteDataSource: MockMovieRemoteDataSource
    let mockLocalDataSource: MockPopularMovieLocalDataSource

    init() {
        self.mockRemoteDataSource = MockMovieRemoteDataSource()
        self.mockLocalDataSource = MockPopularMovieLocalDataSource()
    }

    @Test("popular returns the cached page and does not hit remote on a cache hit")
    func popularReturnsCachedPageWithoutRemoteOnHit() async throws {
        let cachedPage = MoviePreviewPage(page: 1, totalPages: 5, movies: MoviePreview.mocks)
        mockLocalDataSource.popularStub = .success(cachedPage)

        let repository = makeRepository()

        let result = try await repository.popular(page: 1)

        #expect(result == cachedPage)
        #expect(mockRemoteDataSource.popularCallCount == 0)
    }

    @Test("popular fetches from remote and writes through on a cache miss")
    func popularFetchesRemoteAndWritesThroughOnMiss() async throws {
        let remotePage = MoviePreviewPage(page: 1, totalPages: 5, movies: MoviePreview.mocks)
        mockLocalDataSource.popularStub = .success(nil)
        mockLocalDataSource.setPopularStub = .success(())
        mockRemoteDataSource.popularStub = .success(remotePage)

        let repository = makeRepository()

        let result = try await repository.popular(page: 1)

        #expect(result == remotePage)
        #expect(mockRemoteDataSource.popularCallCount == 1)
        #expect(mockLocalDataSource.setPopularCallCount == 1)
        #expect(mockLocalDataSource.setPopularCalledWith.first == remotePage)
    }

    @Test("popular still returns the remote page when the write-through fails")
    func popularReturnsRemotePageWhenWriteThroughFails() async throws {
        let remotePage = MoviePreviewPage(page: 2, totalPages: 5, movies: MoviePreview.mocks)
        mockLocalDataSource.popularStub = .success(nil)
        mockLocalDataSource.setPopularStub = .failure(.unknown(nil))
        mockRemoteDataSource.popularStub = .success(remotePage)

        let repository = makeRepository()

        let result = try await repository.popular(page: 2)

        #expect(result == remotePage)
    }

    @Test("popular throws not found when remote throws not found")
    func popularThrowsNotFoundWhenRemoteThrowsNotFound() async {
        mockLocalDataSource.popularStub = .success(nil)
        mockRemoteDataSource.popularStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.popular(page: 1)
            },
            throws: { error in
                guard let repoError = error as? PopularMovieRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("popular throws unauthorised when remote throws unauthorised")
    func popularThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async {
        mockLocalDataSource.popularStub = .success(nil)
        mockRemoteDataSource.popularStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.popular(page: 1)
            },
            throws: { error in
                guard let repoError = error as? PopularMovieRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("popular throws unknown when the local data source throws a persistence error")
    func popularThrowsUnknownWhenLocalThrowsPersistenceError() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.popularStub = .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.popular(page: 1)
            },
            throws: { error in
                guard let repoError = error as? PopularMovieRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultPopularMovieRepository {
        DefaultPopularMovieRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
