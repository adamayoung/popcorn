//
//  DefaultTVSeriesCreditsRepositoryAggregateTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("DefaultTVSeriesCreditsRepository aggregateCredits")
struct DefaultTVSeriesCreditsRepositoryAggregateTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesCreditsLocalDataSource
    let mockAggregateCreditsLocalDataSource: MockTVSeriesAggregateCreditsLocalDataSource

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesCreditsLocalDataSource()
        self.mockAggregateCreditsLocalDataSource = MockTVSeriesAggregateCreditsLocalDataSource()
    }

    @Test("aggregateCredits returns cached value when available")
    func aggregateCreditsReturnsCachedValueWhenAvailable() async throws {
        let expectedCredits = AggregateCredits.mock(id: 123)
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub = .success(expectedCredits)

        let repository = makeRepository()

        let result = try await repository.aggregateCredits(forTVSeries: 123)

        #expect(result == expectedCredits)
        #expect(mockAggregateCreditsLocalDataSource.aggregateCreditsCallCount == 1)
        #expect(mockRemoteDataSource.aggregateCreditsForTVSeriesCallCount == 0)
    }

    @Test("aggregateCredits fetches from remote when cache is empty")
    func aggregateCreditsFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let expectedCredits = AggregateCredits.mock(id: 456)
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub = .success(nil)
        mockRemoteDataSource.aggregateCreditsForTVSeriesStub = .success(expectedCredits)
        mockAggregateCreditsLocalDataSource.setAggregateCreditsStub = .success(())

        let repository = makeRepository()

        let result = try await repository.aggregateCredits(forTVSeries: 456)

        #expect(result == expectedCredits)
        #expect(mockAggregateCreditsLocalDataSource.aggregateCreditsCallCount == 1)
        #expect(mockRemoteDataSource.aggregateCreditsForTVSeriesCallCount == 1)
    }

    @Test("aggregateCredits caches remote value after fetching")
    func aggregateCreditsCachesRemoteValueAfterFetching() async throws {
        let expectedCredits = AggregateCredits.mock(id: 789)
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub = .success(nil)
        mockRemoteDataSource.aggregateCreditsForTVSeriesStub = .success(expectedCredits)
        mockAggregateCreditsLocalDataSource.setAggregateCreditsStub = .success(())

        let repository = makeRepository()

        _ = try await repository.aggregateCredits(forTVSeries: 789)

        #expect(mockAggregateCreditsLocalDataSource.setAggregateCreditsCallCount == 1)
        #expect(
            mockAggregateCreditsLocalDataSource.setAggregateCreditsCalledWith[0].aggregateCredits
                == expectedCredits
        )
        #expect(
            mockAggregateCreditsLocalDataSource.setAggregateCreditsCalledWith[0].tvSeriesID == 789
        )
    }

    @Test("aggregateCredits passes correct TV series ID to data sources")
    func aggregateCreditsPassesCorrectTVSeriesIDToDataSources() async throws {
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub = .success(nil)
        mockRemoteDataSource.aggregateCreditsForTVSeriesStub = .success(.mock())
        mockAggregateCreditsLocalDataSource.setAggregateCreditsStub = .success(())

        let repository = makeRepository()

        _ = try await repository.aggregateCredits(forTVSeries: 999)

        #expect(mockAggregateCreditsLocalDataSource.aggregateCreditsCalledWith[0] == 999)
        #expect(mockRemoteDataSource.aggregateCreditsForTVSeriesCalledWith[0] == 999)
    }

    @Test("aggregateCredits throws not found when remote throws not found")
    func aggregateCreditsThrowsNotFoundWhenRemoteThrowsNotFound() async {
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub = .success(nil)
        mockRemoteDataSource.aggregateCreditsForTVSeriesStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.aggregateCredits(forTVSeries: 123)
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

    @Test("aggregateCredits throws unknown when local throws persistence error")
    func aggregateCreditsThrowsUnknownWhenLocalThrowsPersistenceError() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub =
            .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.aggregateCredits(forTVSeries: 123)
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

    @Test("aggregateCredits returns remote data when cache write fails")
    func aggregateCreditsReturnsRemoteDataWhenCacheWriteFails() async throws {
        let expectedCredits = AggregateCredits.mock(id: 321)
        mockAggregateCreditsLocalDataSource.aggregateCreditsStub = .success(nil)
        mockRemoteDataSource.aggregateCreditsForTVSeriesStub = .success(expectedCredits)
        let cacheError = NSError(domain: "test", code: 789)
        mockAggregateCreditsLocalDataSource.setAggregateCreditsStub =
            .failure(.persistence(cacheError))

        let repository = makeRepository()

        let result = try await repository.aggregateCredits(forTVSeries: 321)

        #expect(result == expectedCredits)
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultTVSeriesCreditsRepository {
        DefaultTVSeriesCreditsRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource,
            aggregateCreditsLocalDataSource: mockAggregateCreditsLocalDataSource
        )
    }

}
