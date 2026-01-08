//
//  DefaultGenreRepositoryTests.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain
import Testing

@testable import GenresInfrastructure

@Suite("DefaultGenreRepository")
struct DefaultGenreRepositoryTests {

    let mockRemoteDataSource: MockGenreRemoteDataSource
    let mockLocalDataSource: MockGenreLocalDataSource

    init() {
        self.mockRemoteDataSource = MockGenreRemoteDataSource()
        self.mockLocalDataSource = MockGenreLocalDataSource()
    }

    // MARK: - movieGenres Cache Hit Tests

    @Test("movieGenres returns cached value when available")
    func movieGenresReturnsCachedValueWhenAvailable() async throws {
        let cachedGenres = Genre.mocks
        mockLocalDataSource.movieGenresStub = .success(cachedGenres)

        let repository = makeRepository()

        let result = try await repository.movieGenres()

        #expect(result == cachedGenres)
        let localCallCount = await mockLocalDataSource.movieGenresCallCount
        #expect(localCallCount == 1)
        #expect(mockRemoteDataSource.movieGenresCallCount == 0)
    }

    // MARK: - movieGenres Cache Miss Tests

    @Test("movieGenres fetches from remote when cache is empty")
    func movieGenresFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let remoteGenres = Genre.mocks
        mockLocalDataSource.movieGenresStub = .success(nil)
        mockRemoteDataSource.movieGenresStub = .success(remoteGenres)

        let repository = makeRepository()

        let result = try await repository.movieGenres()

        #expect(result == remoteGenres)
        let localCallCount = await mockLocalDataSource.movieGenresCallCount
        #expect(localCallCount == 1)
        #expect(mockRemoteDataSource.movieGenresCallCount == 1)
    }

    @Test("movieGenres caches remote value after fetching")
    func movieGenresCachesRemoteValueAfterFetching() async throws {
        let remoteGenres = Genre.mocks
        mockLocalDataSource.movieGenresStub = .success(nil)
        mockRemoteDataSource.movieGenresStub = .success(remoteGenres)

        let repository = makeRepository()

        _ = try await repository.movieGenres()

        let setCallCount = await mockLocalDataSource.setMovieGenresCallCount
        #expect(setCallCount == 1)
        let calledWith = await mockLocalDataSource.setMovieGenresCalledWith
        #expect(calledWith[0] == remoteGenres)
    }

    // MARK: - movieGenres Error Tests

    @Test("movieGenres throws error when local data source fails")
    func movieGenresThrowsErrorWhenLocalDataSourceFails() async throws {
        let underlyingError = NSError(domain: "test", code: 123)
        mockLocalDataSource.movieGenresStub = .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movieGenres()
            },
            throws: { error in
                guard let repoError = error as? GenreRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("movieGenres throws unauthorised error when remote throws unauthorised")
    func movieGenresThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async throws {
        mockLocalDataSource.movieGenresStub = .success(nil)
        mockRemoteDataSource.movieGenresStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movieGenres()
            },
            throws: { error in
                guard let repoError = error as? GenreRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("movieGenres throws unknown error when remote throws unknown")
    func movieGenresThrowsUnknownWhenRemoteThrowsUnknown() async throws {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.movieGenresStub = .success(nil)
        mockRemoteDataSource.movieGenresStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movieGenres()
            },
            throws: { error in
                guard let repoError = error as? GenreRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - tvSeriesGenres Cache Hit Tests

    @Test("tvSeriesGenres returns cached value when available")
    func tvSeriesGenresReturnsCachedValueWhenAvailable() async throws {
        let cachedGenres = Genre.mocks
        mockLocalDataSource.tvSeriesGenresStub = .success(cachedGenres)

        let repository = makeRepository()

        let result = try await repository.tvSeriesGenres()

        #expect(result == cachedGenres)
        let localCallCount = await mockLocalDataSource.tvSeriesGenresCallCount
        #expect(localCallCount == 1)
        #expect(mockRemoteDataSource.tvSeriesGenresCallCount == 0)
    }

    // MARK: - tvSeriesGenres Cache Miss Tests

    @Test("tvSeriesGenres fetches from remote when cache is empty")
    func tvSeriesGenresFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let remoteGenres = Genre.mocks
        mockLocalDataSource.tvSeriesGenresStub = .success(nil)
        mockRemoteDataSource.tvSeriesGenresStub = .success(remoteGenres)

        let repository = makeRepository()

        let result = try await repository.tvSeriesGenres()

        #expect(result == remoteGenres)
        let localCallCount = await mockLocalDataSource.tvSeriesGenresCallCount
        #expect(localCallCount == 1)
        #expect(mockRemoteDataSource.tvSeriesGenresCallCount == 1)
    }

    @Test("tvSeriesGenres caches remote value after fetching")
    func tvSeriesGenresCachesRemoteValueAfterFetching() async throws {
        let remoteGenres = Genre.mocks
        mockLocalDataSource.tvSeriesGenresStub = .success(nil)
        mockRemoteDataSource.tvSeriesGenresStub = .success(remoteGenres)

        let repository = makeRepository()

        _ = try await repository.tvSeriesGenres()

        let setCallCount = await mockLocalDataSource.setTVSeriesGenresCallCount
        #expect(setCallCount == 1)
        let calledWith = await mockLocalDataSource.setTVSeriesGenresCalledWith
        #expect(calledWith[0] == remoteGenres)
    }

    // MARK: - tvSeriesGenres Error Tests

    @Test("tvSeriesGenres throws error when local data source fails")
    func tvSeriesGenresThrowsErrorWhenLocalDataSourceFails() async throws {
        let underlyingError = NSError(domain: "test", code: 123)
        mockLocalDataSource.tvSeriesGenresStub = .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.tvSeriesGenres()
            },
            throws: { error in
                guard let repoError = error as? GenreRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("tvSeriesGenres throws unauthorised error when remote throws unauthorised")
    func tvSeriesGenresThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async throws {
        mockLocalDataSource.tvSeriesGenresStub = .success(nil)
        mockRemoteDataSource.tvSeriesGenresStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.tvSeriesGenres()
            },
            throws: { error in
                guard let repoError = error as? GenreRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("tvSeriesGenres throws unknown error when remote throws unknown")
    func tvSeriesGenresThrowsUnknownWhenRemoteThrowsUnknown() async throws {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.tvSeriesGenresStub = .success(nil)
        mockRemoteDataSource.tvSeriesGenresStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.tvSeriesGenres()
            },
            throws: { error in
                guard let repoError = error as? GenreRepositoryError else {
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

    private func makeRepository() -> DefaultGenreRepository {
        DefaultGenreRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
