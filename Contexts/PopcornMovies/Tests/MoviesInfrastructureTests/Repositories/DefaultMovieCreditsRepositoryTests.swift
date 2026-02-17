//
//  DefaultMovieCreditsRepositoryTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import Testing

@Suite("DefaultMovieCreditsRepository")
struct DefaultMovieCreditsRepositoryTests {

    let mockRemoteDataSource: MockMovieRemoteDataSource
    let mockLocalDataSource: MockMovieCreditsLocalDataSource

    init() {
        self.mockRemoteDataSource = MockMovieRemoteDataSource()
        self.mockLocalDataSource = MockMovieCreditsLocalDataSource()
    }

    // MARK: - credits() Tests

    @Test("credits returns cached value when available")
    func creditsReturnsCachedValueWhenAvailable() async throws {
        let expectedCredits = Credits.mock(id: 123)
        mockLocalDataSource.creditsStub = .success(expectedCredits)

        let repository = makeRepository()

        let result = try await repository.credits(forMovie: 123)

        #expect(result == expectedCredits)
        #expect(mockLocalDataSource.creditsCallCount == 1)
        #expect(mockRemoteDataSource.creditsCallCount == 0)
    }

    @Test("credits fetches from remote when cache is empty")
    func creditsFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let expectedCredits = Credits.mock(id: 456)
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsStub = .success(expectedCredits)
        mockLocalDataSource.setCreditsStub = .success(())

        let repository = makeRepository()

        let result = try await repository.credits(forMovie: 456)

        #expect(result == expectedCredits)
        #expect(mockLocalDataSource.creditsCallCount == 1)
        #expect(mockRemoteDataSource.creditsCallCount == 1)
    }

    @Test("credits caches remote value after fetching")
    func creditsCachesRemoteValueAfterFetching() async throws {
        let expectedCredits = Credits.mock(id: 789)
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsStub = .success(expectedCredits)
        mockLocalDataSource.setCreditsStub = .success(())

        let repository = makeRepository()

        _ = try await repository.credits(forMovie: 789)

        #expect(mockLocalDataSource.setCreditsCallCount == 1)
        #expect(mockLocalDataSource.setCreditsCalledWith[0].credits == expectedCredits)
        #expect(mockLocalDataSource.setCreditsCalledWith[0].movieID == 789)
    }

    @Test("credits passes correct movie ID to data sources")
    func creditsPassesCorrectMovieIDToDataSources() async throws {
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsStub = .success(.mock())
        mockLocalDataSource.setCreditsStub = .success(())

        let repository = makeRepository()

        _ = try await repository.credits(forMovie: 999)

        #expect(mockLocalDataSource.creditsCalledWith[0] == 999)
        #expect(mockRemoteDataSource.creditsCalledWith[0] == 999)
    }

    @Test("credits throws not found when remote throws not found")
    func creditsThrowsNotFoundWhenRemoteThrowsNotFound() async {
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieCreditsRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("credits throws unauthorised when remote throws unauthorised")
    func creditsThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async {
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieCreditsRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("credits throws unknown when remote throws unknown")
    func creditsThrowsUnknownWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieCreditsRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("credits throws unknown when local data source throws persistence error")
    func creditsThrowsUnknownWhenLocalThrowsPersistenceError() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.creditsStub = .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieCreditsRepositoryError else {
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

    private func makeRepository() -> DefaultMovieCreditsRepository {
        DefaultMovieCreditsRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
