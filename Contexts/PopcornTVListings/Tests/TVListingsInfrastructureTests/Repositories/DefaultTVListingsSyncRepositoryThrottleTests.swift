//
//  DefaultTVListingsSyncRepositoryThrottleTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("DefaultTVListingsSyncRepository syncIfNeeded")
struct DefaultTVListingsSyncRepositoryThrottleTests {

    private let throttle: TimeInterval = 12 * 60 * 60
    private let nowDate = Date(timeIntervalSince1970: 1_000_000)

    @Test("syncIfNeeded runs when never synced before")
    func syncIfNeededRunsWhenNeverSynced() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        await local.setLastSyncedAtStub(.success(nil))

        let repository = makeRepository(remote: remote, local: local)

        try await repository.syncIfNeeded()

        #expect(remote.fetchManifestCallCount == 1)
    }

    @Test("syncIfNeeded skips and makes no network call within the throttle window")
    func syncIfNeededSkipsWithinThrottle() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        await local.setLastSyncedAtStub(.success(nowDate.addingTimeInterval(-(throttle - 1))))

        let repository = makeRepository(remote: remote, local: local)

        try await repository.syncIfNeeded()

        #expect(remote.fetchManifestCallCount == 0)
    }

    @Test("syncIfNeeded runs exactly at the throttle boundary")
    func syncIfNeededRunsAtThrottleBoundary() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        await local.setLastSyncedAtStub(.success(nowDate.addingTimeInterval(-throttle)))

        let repository = makeRepository(remote: remote, local: local)

        try await repository.syncIfNeeded()

        #expect(remote.fetchManifestCallCount == 1, "elapsed == throttle is not < throttle → runs")
    }

    @Test("syncIfNeeded maps a lastSyncedAt read failure and makes no network call")
    func syncIfNeededMapsLastSyncedAtFailure() async {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        await local.setLastSyncedAtStub(.failure(.persistence(NSError(domain: "t", code: 1))))

        let repository = makeRepository(remote: remote, local: local)

        await #expect(
            performing: { try await repository.syncIfNeeded() },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError, case .local = repoError else {
                    return false
                }
                return true
            }
        )
        #expect(remote.fetchManifestCallCount == 0)
    }

    @Test("overlapping syncs coalesce onto a single network sequence")
    func overlappingSyncsCoalesce() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        let firstEntered = TestSignal()
        let releaseManifest = TestSignal()
        let secondCoalesced = TestSignal()
        remote.onFetchManifest = {
            await firstEntered.signal()
            await releaseManifest.wait()
        }

        // The repository fires `onCoalesce` exactly when the second caller takes the
        // coalescing branch, giving a deterministic signal with no reliance on Task.yield.
        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: remote,
            localDataSource: local,
            syncThrottle: throttle,
            now: { nowDate },
            onCoalesce: { Task { await secondCoalesced.signal() } }
        )

        let first = Task { try await repository.sync() }
        await firstEntered.wait() // first sync is inside fetchManifest; inFlight is set
        let second = Task { try await repository.sync() }
        await secondCoalesced.wait() // second caller has provably coalesced
        await releaseManifest.signal()

        try await first.value
        try await second.value

        #expect(remote.fetchManifestCallCount == 1)
    }

    private func makeRepository(
        remote: MockTVListingsRemoteDataSource,
        local: MockTVListingsLocalDataSource
    ) -> DefaultTVListingsSyncRepository {
        DefaultTVListingsSyncRepository(
            remoteDataSource: remote,
            localDataSource: local,
            syncThrottle: throttle,
            now: { nowDate }
        )
    }

}
