//
//  DefaultTVSeriesCreditsRepositoryTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("DefaultTVSeriesCreditsRepository")
struct DefaultTVSeriesCreditsRepositoryTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesCreditsLocalDataSource

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesCreditsLocalDataSource()
    }

    // MARK: - credits() Tests

    @Test("credits returns cached value when available")
    func creditsReturnsCachedValueWhenAvailable() async throws {
        let expectedCredits = Credits.mock(id: 123)
        mockLocalDataSource.creditsStub = .success(expectedCredits)

        let repository = makeRepository()

        let result = try await repository.credits(forTVSeries: 123)

        #expect(result == expectedCredits)
        #expect(mockLocalDataSource.creditsCallCount == 1)
        #expect(mockRemoteDataSource.creditsForTVSeriesCallCount == 0)
    }

    @Test("credits fetches from remote when cache is empty")
    func creditsFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let expectedCredits = Credits.mock(id: 456)
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsForTVSeriesStub = .success(expectedCredits)
        mockLocalDataSource.setCreditsStub = .success(())

        let repository = makeRepository()

        let result = try await repository.credits(forTVSeries: 456)

        #expect(result == expectedCredits)
        #expect(mockLocalDataSource.creditsCallCount == 1)
        #expect(mockRemoteDataSource.creditsForTVSeriesCallCount == 1)
    }

    @Test("credits caches remote value after fetching")
    func creditsCachesRemoteValueAfterFetching() async throws {
        let expectedCredits = Credits.mock(id: 789)
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsForTVSeriesStub = .success(expectedCredits)
        mockLocalDataSource.setCreditsStub = .success(())

        let repository = makeRepository()

        _ = try await repository.credits(forTVSeries: 789)

        #expect(mockLocalDataSource.setCreditsCallCount == 1)
        #expect(mockLocalDataSource.setCreditsCalledWith[0].credits == expectedCredits)
        #expect(mockLocalDataSource.setCreditsCalledWith[0].tvSeriesID == 789)
    }

    @Test("credits passes correct TV series ID to data sources")
    func creditsPassesCorrectTVSeriesIDToDataSources() async throws {
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsForTVSeriesStub = .success(.mock())
        mockLocalDataSource.setCreditsStub = .success(())

        let repository = makeRepository()

        _ = try await repository.credits(forTVSeries: 999)

        #expect(mockLocalDataSource.creditsCalledWith[0] == 999)
        #expect(mockRemoteDataSource.creditsForTVSeriesCalledWith[0] == 999)
    }

    @Test("credits throws not found when remote throws not found")
    func creditsThrowsNotFoundWhenRemoteThrowsNotFound() async {
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsForTVSeriesStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forTVSeries: 123)
            },
            throws: { error in
                guard let repoError = error as? TVSeriesCreditsRepositoryError else {
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
        mockRemoteDataSource.creditsForTVSeriesStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forTVSeries: 123)
            },
            throws: { error in
                guard let repoError = error as? TVSeriesCreditsRepositoryError else {
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
        mockRemoteDataSource.creditsForTVSeriesStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.credits(forTVSeries: 123)
            },
            throws: { error in
                guard let repoError = error as? TVSeriesCreditsRepositoryError else {
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
                try await repository.credits(forTVSeries: 123)
            },
            throws: { error in
                guard let repoError = error as? TVSeriesCreditsRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("credits returns remote data when cache write fails")
    func creditsReturnsRemoteDataWhenCacheWriteFails() async throws {
        let expectedCredits = Credits.mock(id: 321)
        mockLocalDataSource.creditsStub = .success(nil)
        mockRemoteDataSource.creditsForTVSeriesStub = .success(expectedCredits)
        let cacheError = NSError(domain: "test", code: 789)
        mockLocalDataSource.setCreditsStub = .failure(.persistence(cacheError))

        let repository = makeRepository()

        let result = try await repository.credits(forTVSeries: 321)

        #expect(result == expectedCredits)
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultTVSeriesCreditsRepository {
        DefaultTVSeriesCreditsRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
