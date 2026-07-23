//
//  DefaultTVSeriesRepositoryStreamTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomainTestHelpers
import Foundation
import Testing
import TVSeriesDomain
@testable import TVSeriesInfrastructure

@Suite("DefaultTVSeriesRepository Stream Tests")
struct DefaultTVSeriesRepositoryStreamTests {

    let mockRemoteDataSource: MockTVSeriesRemoteDataSource
    let mockLocalDataSource: MockTVSeriesLocalDataSource

    init() {
        self.mockRemoteDataSource = MockTVSeriesRemoteDataSource()
        self.mockLocalDataSource = MockTVSeriesLocalDataSource()
    }

    @Test("tvSeriesStream returns the local stream and refreshes from remote")
    func tvSeriesStream_returnsLocalStreamAndRefreshesFromRemote() async throws {
        let id = 1396
        let cached = TVSeries.mock(id: id, name: "Breaking Bad")
        let remote = TVSeries.mock(id: id, name: "Breaking Bad (fresh)")
        mockLocalDataSource.tvSeriesStreamValues = [cached]
        mockRemoteDataSource.tvSeriesWithIDStub = .success(remote)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let stream = await repository.tvSeriesStream(withID: id)

        // The returned stream is the local data source's stream (pass-through).
        var iterator = stream.makeAsyncIterator()
        let first = try await iterator.next()
        #expect(first ?? nil == cached)
        #expect(await mockLocalDataSource.tvSeriesStreamCallCount == 1)
        #expect(await mockLocalDataSource.tvSeriesStreamCalledWith == [id])

        // The background refresh fetches from remote and writes it back to the cache.
        let local = mockLocalDataSource
        try await waitUntil { await local.setTVSeriesCallCount == 1 }
        #expect(mockRemoteDataSource.tvSeriesWithIDCallCount == 1)
        #expect(await local.setTVSeriesCalledWith.first?.name == "Breaking Bad (fresh)")
    }

    @Test("tvSeriesStream still yields the cached value when the remote refresh fails")
    func tvSeriesStream_stillYieldsCachedWhenRemoteRefreshFails() async throws {
        let id = 1396
        let cached = TVSeries.mock(id: id, name: "Breaking Bad")
        mockLocalDataSource.tvSeriesStreamValues = [cached]
        mockRemoteDataSource.tvSeriesWithIDStub = .failure(.notFound)

        let repository = DefaultTVSeriesRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )

        let stream = await repository.tvSeriesStream(withID: id)
        var iterator = stream.makeAsyncIterator()
        let first = try await iterator.next()
        #expect(first ?? nil == cached)

        // The background refresh attempts the remote fetch, which fails — so nothing is cached.
        let remote = mockRemoteDataSource
        try await waitUntil { remote.tvSeriesWithIDCallCount == 1 }
        #expect(await mockLocalDataSource.setTVSeriesCallCount == 0)
    }

    /// Polls `condition` (max ~2s) so a racy background `Task` can be asserted deterministically.
    private func waitUntil(_ condition: () async -> Bool) async throws {
        for _ in 0 ..< 200 {
            if await condition() {
                return
            }
            try await Task.sleep(for: .milliseconds(10))
        }
        Issue.record("Condition was not met within the timeout")
    }

}
