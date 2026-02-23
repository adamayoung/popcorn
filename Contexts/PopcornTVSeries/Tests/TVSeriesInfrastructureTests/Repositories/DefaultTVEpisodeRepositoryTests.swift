//
//  DefaultTVEpisodeRepositoryTests.swift
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

@Suite("DefaultTVEpisodeRepository")
struct DefaultTVEpisodeRepositoryTests {

    let mockRemoteDataSource: MockTVEpisodeRemoteDataSource
    let mockLocalDataSource: MockTVEpisodeLocalDataSource
    let mockObservabilityProvider: MockObservabilityProvider

    init() {
        self.mockRemoteDataSource = MockTVEpisodeRemoteDataSource()
        self.mockLocalDataSource = MockTVEpisodeLocalDataSource()
        self.mockObservabilityProvider = MockObservabilityProvider()
    }

    // MARK: - Cache Hit

    @Test("episode should return from cache when available")
    func episode_shouldReturnFromCacheWhenAvailable() async throws {
        let cachedEpisode = TVEpisode.mock(overview: "Cached overview")
        mockLocalDataSource.episodeStub = .success(cachedEpisode)

        let repository = makeRepository()

        let result = try await repository.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result.overview == "Cached overview")
        #expect(await mockLocalDataSource.episodeCallCount == 1)
        #expect(mockRemoteDataSource.episodeCallCount == 0)
    }

    @Test("episode should set cache hit true on span")
    func episode_shouldSetCacheHitTrueOnSpan() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.episodeStub = .success(TVEpisode.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first { $0.key == "cache.hit" }
        #expect(cacheHitEntry?.value == "true")
    }

    // MARK: - Cache Miss → Remote Fallback

    @Test("episode should fetch from remote on cache miss")
    func episode_shouldFetchFromRemoteOnCacheMiss() async throws {
        let remoteEpisode = TVEpisode.mock(overview: "Remote overview")
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .success(remoteEpisode)

        let repository = makeRepository()

        let result = try await repository.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result.overview == "Remote overview")
        #expect(await mockLocalDataSource.episodeCallCount == 1)
        #expect(mockRemoteDataSource.episodeCallCount == 1)
    }

    @Test("episode should set cache hit false on span for remote fetch")
    func episode_shouldSetCacheHitFalseOnSpan() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .success(TVEpisode.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
        }

        let cacheHitEntry = mockSpan.setDataCalledWith.first { $0.key == "cache.hit" }
        #expect(cacheHitEntry?.value == "false")
    }

    @Test("episode should cache remote result")
    func episode_shouldCacheRemoteResult() async throws {
        let remoteEpisode = TVEpisode.mock(overview: "Cached overview")
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .success(remoteEpisode)

        let repository = makeRepository()

        _ = try await repository.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(await mockLocalDataSource.setEpisodeCallCount == 1)
        let cached = await mockLocalDataSource.setEpisodeCalledWith[0]
        #expect(cached.episode.overview == "Cached overview")
        #expect(cached.tvSeriesID == 1396)
    }

    // MARK: - Span Operations

    @Test("episode should create span with correct operation")
    func episode_shouldCreateSpanWithCorrectOperation() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.episodeStub = .success(TVEpisode.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
        }

        #expect(mockSpan.startChildCallCount == 1)
        #expect(
            mockSpan.startChildCalledWith[0].operation.value
                == SpanOperation.repositoryGet.value
        )
    }

    @Test("episode should finish span on success")
    func episode_shouldFinishSpanOnSuccess() async throws {
        let mockSpan = MockSpan()
        mockLocalDataSource.episodeStub = .success(TVEpisode.mock())
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        _ = try await SpanContext.$localProvider.withValue(mockObservabilityProvider) {
            try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
        }

        #expect(mockSpan.finishCallCount == 1)
        #expect(mockSpan.finishCalledWithStatus[0] == .ok)
    }

    // MARK: - Error Propagation

    @Test("episode should throw notFound on remote not found")
    func episode_shouldThrowNotFoundOnRemoteNotFound() async {
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                if case .notFound = error as? TVEpisodeRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("episode should throw unauthorised on remote unauthorised")
    func episode_shouldThrowUnauthorisedOnRemoteUnauthorised() async {
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                if case .unauthorised = error as? TVEpisodeRepositoryError {
                    return true
                }
                return false
            }
        )
    }

    @Test("episode should throw on local cache error")
    func episode_shouldThrowOnLocalCacheError() async {
        mockLocalDataSource.episodeStub = .failure(.unknown())

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
            },
            throws: { error in
                error is TVEpisodeRepositoryError
            }
        )
    }

    @Test("episode should return remote data when cache save fails")
    func episode_shouldReturnRemoteDataWhenCacheSaveFails() async throws {
        let expectedEpisode = TVEpisode.mock()
        mockLocalDataSource.episodeStub = .success(nil)
        mockLocalDataSource.setEpisodeStub = .failure(.unknown())
        mockRemoteDataSource.episodeStub = .success(expectedEpisode)

        let repository = makeRepository()

        let result = try await repository.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result == expectedEpisode)
    }

    @Test("episode should set error on span on remote failure")
    func episode_shouldSetErrorOnSpanOnRemoteFailure() async {
        let mockSpan = MockSpan()
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .failure(.notFound)
        mockObservabilityProvider.currentSpanStub = mockSpan
        mockSpan.childSpanStub = mockSpan

        let repository = makeRepository()

        await #expect(
            performing: {
                try await SpanContext.$localProvider.withValue(
                    mockObservabilityProvider
                ) {
                    try await repository.episode(1, inSeason: 1, inTVSeries: 1396)
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

    @Test("episode should handle nil overview")
    func episode_shouldHandleNilOverview() async throws {
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .success(TVEpisode.mock(overview: nil))

        let repository = makeRepository()

        let result = try await repository.episode(1, inSeason: 1, inTVSeries: 1396)

        #expect(result.overview == nil)
    }

    @Test("episode should pass correct parameters to data sources")
    func episode_shouldPassCorrectParametersToDataSources() async throws {
        mockLocalDataSource.episodeStub = .success(nil)
        mockRemoteDataSource.episodeStub = .success(TVEpisode.mock())

        let repository = makeRepository()

        _ = try await repository.episode(5, inSeason: 3, inTVSeries: 456)

        let localCall = await mockLocalDataSource.episodeCalledWith[0]
        #expect(localCall.episodeNumber == 5)
        #expect(localCall.seasonNumber == 3)
        #expect(localCall.tvSeriesID == 456)
        #expect(mockRemoteDataSource.episodeCalledWith[0].episodeNumber == 5)
        #expect(mockRemoteDataSource.episodeCalledWith[0].seasonNumber == 3)
        #expect(mockRemoteDataSource.episodeCalledWith[0].tvSeriesID == 456)
    }

}

extension DefaultTVEpisodeRepositoryTests {

    private func makeRepository() -> DefaultTVEpisodeRepository {
        DefaultTVEpisodeRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
