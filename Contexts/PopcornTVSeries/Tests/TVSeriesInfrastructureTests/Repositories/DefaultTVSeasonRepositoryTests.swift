//
//  DefaultTVSeasonRepositoryTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import ObservabilityTestHelpers
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("DefaultTVSeasonRepository")
struct DefaultTVSeasonRepositoryTests {

    let mockRemoteDataSource: MockTVSeasonRemoteDataSource
    let mockLocalDataSource: MockTVSeasonLocalDataSource
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRemoteDataSource = MockTVSeasonRemoteDataSource()
        self.mockLocalDataSource = MockTVSeasonLocalDataSource()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    // MARK: - Cache Hit

    @Test("season should return from cache when available")
    func season_shouldReturnFromCacheWhenAvailable() async throws {
        let cachedSeason = TVSeason.mock(
            overview: "Season overview",
            episodes: [TVEpisode.mock(id: 1), TVEpisode.mock(id: 2)]
        )
        mockLocalDataSource.seasonStub = .success(cachedSeason)

        let repository = makeRepository()

        let result = try await repository.season(1, inTVSeries: 1396)

        #expect(result.overview == "Season overview")
        #expect(result.episodes.count == 2)
        #expect(await mockLocalDataSource.seasonCallCount == 1)
        #expect(mockRemoteDataSource.seasonCallCount == 0)
    }

    @Test("season should set cache hit true on span")
    func season_shouldSetCacheHitTrueOnSpan() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.seasonStub = .success(TVSeason.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.season(1, inTVSeries: 1396)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first { $0.key == "cache.hit" }
        #expect(cacheHitEntry?.value == "true")
    }

    // MARK: - Cache Miss → Remote Fallback

    @Test("season should fetch from remote on cache miss")
    func season_shouldFetchFromRemoteOnCacheMiss() async throws {
        let remoteSeason = TVSeason.mock(
            overview: "Remote overview",
            episodes: [TVEpisode.mock(id: 1)]
        )
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .success(remoteSeason)

        let repository = makeRepository()

        let result = try await repository.season(1, inTVSeries: 1396)

        #expect(result.overview == "Remote overview")
        #expect(result.episodes.count == 1)
        #expect(await mockLocalDataSource.seasonCallCount == 1)
        #expect(mockRemoteDataSource.seasonCallCount == 1)
    }

    @Test("season should set cache hit false on span for remote fetch")
    func season_shouldSetCacheHitFalseOnSpan() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .success(TVSeason.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.season(1, inTVSeries: 1396)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first { $0.key == "cache.hit" }
        #expect(cacheHitEntry?.value == "false")
    }

    @Test("season should cache remote result")
    func season_shouldCacheRemoteResult() async throws {
        let remoteSeason = TVSeason.mock(
            overview: "Cached overview",
            episodes: [TVEpisode.mock(id: 1)]
        )
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .success(remoteSeason)

        let repository = makeRepository()

        _ = try await repository.season(2, inTVSeries: 1396)

        #expect(await mockLocalDataSource.setSeasonCallCount == 1)
        let cached = await mockLocalDataSource.setSeasonCalledWith[0]
        #expect(cached.season.overview == "Cached overview")
        #expect(cached.season.episodes.count == 1)
        #expect(cached.tvSeriesID == 1396)
    }

    // MARK: - Span Operations

    @Test("season should create span with correct operation")
    func season_shouldCreateSpanWithCorrectOperation() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.seasonStub = .success(TVSeason.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.season(1, inTVSeries: 1396)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.repositoryGet.value
        )
    }

    @Test("season should finish span on success")
    func season_shouldFinishSpanOnSuccess() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.seasonStub = .success(TVSeason.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.season(1, inTVSeries: 1396)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    // MARK: - Error Propagation

    @Test("season should throw notFound on remote not found")
    func season_shouldThrowNotFoundOnRemoteNotFound() async {
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.season(1, inTVSeries: 1396)
            },
            throws: { error in
                if case .notFound = error as? TVSeasonRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("season should throw unauthorised on remote unauthorised")
    func season_shouldThrowUnauthorisedOnRemoteUnauthorised() async {
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.season(1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unauthorised = error as? TVSeasonRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("season should throw on local cache error")
    func season_shouldThrowOnLocalCacheError() async {
        mockLocalDataSource.seasonStub = .failure(.unknown())

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.season(1, inTVSeries: 1396)
            },
            throws: { error in
                error is TVSeasonRepositoryError
            }
        )
    }

    @Test("season should throw on local cache save error")
    func season_shouldThrowOnLocalCacheSaveError() async {
        mockLocalDataSource.seasonStub = .success(nil)
        mockLocalDataSource.setSeasonStub = .failure(.unknown())
        mockRemoteDataSource.seasonStub = .success(TVSeason.mock())

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.season(1, inTVSeries: 1396)
            },
            throws: { error in
                error is TVSeasonRepositoryError
            }
        )
    }

    @Test("season should set error on span on remote failure")
    func season_shouldSetErrorOnSpanOnRemoteFailure() async {
        let mockSpan = MockSpan()
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .failure(.notFound)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(
                    mockObservabilityProvider
                ) {
                    try await repository.season(1, inTVSeries: 1396)
                }
            },
            throws: { _ in true }
        )

        let errorEntry = mockSpan.setDataCalledWith.first { $0.key == "error" }
        #expect(errorEntry != nil)
        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .internalError)
    }

    // MARK: - Edge Cases

    @Test("season should handle empty episodes")
    func season_shouldHandleEmptyEpisodes() async throws {
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .success(
            TVSeason.mock(overview: "Overview only", episodes: [])
        )

        let repository = makeRepository()

        let result = try await repository.season(1, inTVSeries: 1396)

        #expect(result.overview == "Overview only")
        #expect(result.episodes.isEmpty)
    }

    @Test("season should handle nil overview")
    func season_shouldHandleNilOverview() async throws {
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .success(
            TVSeason.mock(overview: nil, episodes: [TVEpisode.mock()])
        )

        let repository = makeRepository()

        let result = try await repository.season(1, inTVSeries: 1396)

        #expect(result.overview == nil)
        #expect(result.episodes.count == 1)
    }

    @Test("season should pass correct parameters to data sources")
    func season_shouldPassCorrectParametersToDataSources() async throws {
        mockLocalDataSource.seasonStub = .success(nil)
        mockRemoteDataSource.seasonStub = .success(TVSeason.mock())

        let repository = makeRepository()

        _ = try await repository.season(3, inTVSeries: 456)

        let localCall = await mockLocalDataSource.seasonCalledWith[0]
        #expect(localCall.seasonNumber == 3)
        #expect(localCall.tvSeriesID == 456)
        #expect(mockRemoteDataSource.seasonCalledWith[0].seasonNumber == 3)
        #expect(mockRemoteDataSource.seasonCalledWith[0].tvSeriesID == 456)
    }

}

extension DefaultTVSeasonRepositoryTests {

    private func makeRepository() -> DefaultTVSeasonRepository {
        DefaultTVSeasonRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
