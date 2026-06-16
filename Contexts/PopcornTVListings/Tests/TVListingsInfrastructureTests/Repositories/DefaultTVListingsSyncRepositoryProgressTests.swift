//
//  DefaultTVListingsSyncRepositoryProgressTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Synchronization
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("DefaultTVListingsSyncRepository progress")
struct DefaultTVListingsSyncRepositoryProgressTests {

    @Test("a full sync emits non-decreasing progress ending at 1.0")
    func fullSyncEmitsMonotonicProgressEndingAtOne() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(
                dates: ["20260611", "20260612"],
                channelsHash: "c1",
                regionsHash: "r1",
                scheduleHashes: ["20260611": "s1", "20260612": "s2"]
            )
        )
        remote.fetchChannelsStub = .success([Channel.mock(id: "BBC")])
        remote.fetchRegionsStub = .success([
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        ])
        remote.fetchScheduleDefaultStub = .success([TVProgramme.mock(channelID: "BBC")])

        let repository = makeRepository(remote: remote, local: local)
        let recorder = ProgressRecorder()

        try await repository.sync { recorder.append($0) }

        let values = recorder.values
        #expect((values.first ?? 0) > 0, "the manifest unit means progress leaves 0% immediately")
        #expect(values.last == 1.0)
        #expect(values == values.sorted(), "progress must be non-decreasing")
    }

    @Test("progress is weighted by the number of files to download")
    func progressIsWeightedByFileCount() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        // manifest (1) + channels (1) + regions (1) + 2 changed days = 5 units.
        remote.fetchManifestStub = .success(
            .mock(
                dates: ["20260611", "20260612"],
                channelsHash: "c1",
                regionsHash: "r1",
                scheduleHashes: ["20260611": "s1", "20260612": "s2"]
            )
        )
        remote.fetchChannelsStub = .success([Channel.mock(id: "BBC")])
        remote.fetchRegionsStub = .success([
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        ])
        remote.fetchScheduleDefaultStub = .success([TVProgramme.mock(channelID: "BBC")])

        let repository = makeRepository(remote: remote, local: local)
        let recorder = ProgressRecorder()

        try await repository.sync { recorder.append($0) }

        // manifest, channels, regions, then each of the 2 days, then the explicit final 1.0.
        // Day completion order is arbitrary, but each step advances the same shared counter,
        // so the fraction sequence is deterministic regardless of which day finished first.
        let total: Float = 5
        let expected: [Float] = [1, 2, 3, 4, 5].map { $0 / total } + [1.0]
        #expect(recorder.values == expected)
    }

    @Test("a sync with nothing changed still ends at 1.0 (no divide-by-zero)")
    func unchangedSyncEndsAtOne() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: "c1", scheduleHashes: ["20260611": "s1"])
        )
        await local.setFileStatesStub(.success([
            "channels.json": "c1",
            "schedules/20260611.json": "s1"
        ]))

        let repository = makeRepository(remote: remote, local: local)
        let recorder = ProgressRecorder()

        try await repository.sync { recorder.append($0) }

        #expect(recorder.values.allSatisfy { $0 == 1.0 })
        #expect(recorder.values.last == 1.0)
    }

    @Test("a throttled no-op emits no progress")
    func throttledNoOpEmitsNoProgress() async throws {
        let throttle: TimeInterval = 12 * 60 * 60
        let nowDate = Date(timeIntervalSince1970: 1_000_000)
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        await local.setLastSyncedAtStub(.success(nowDate.addingTimeInterval(-(throttle - 1))))
        await local.setChannelsStub(.success([Channel.mock(id: "BBC")]))
        await local.setRegionsStub(.success([
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        ]))

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: remote,
            localDataSource: local,
            syncThrottle: throttle,
            now: { nowDate }
        )
        let recorder = ProgressRecorder()

        try await repository.syncIfNeeded(onProgress: { recorder.append($0) })

        #expect(remote.fetchManifestCallCount == 0, "throttled → no network")
        #expect(recorder.values.isEmpty, "throttled no-op reports no progress")
    }

    @Test("a coalescing caller receives no progress; only the starter does")
    func coalescingCallerReceivesNoProgress() async throws {
        let throttle: TimeInterval = 12 * 60 * 60
        let nowDate = Date(timeIntervalSince1970: 1_000_000)
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        let firstEntered = TestSignal()
        let releaseManifest = TestSignal()
        let secondCoalesced = TestSignal()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: "c1", scheduleHashes: ["20260611": "s1"])
        )
        remote.fetchChannelsStub = .success([Channel.mock(id: "BBC")])
        remote.fetchScheduleDefaultStub = .success([TVProgramme.mock(channelID: "BBC")])
        remote.onFetchManifest = {
            await firstEntered.signal()
            await releaseManifest.wait()
        }

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: remote,
            localDataSource: local,
            syncThrottle: throttle,
            now: { nowDate },
            onCoalesce: { Task { await secondCoalesced.signal() } }
        )

        let starterProgress = ProgressRecorder()
        let coalescingProgress = ProgressRecorder()

        let first = Task { try await repository.sync { starterProgress.append($0) } }
        await firstEntered.wait()
        let second = Task { try await repository.sync { coalescingProgress.append($0) } }
        await secondCoalesced.wait()
        await releaseManifest.signal()

        try await first.value
        try await second.value

        #expect(!starterProgress.values.isEmpty, "the starter receives progress")
        #expect(starterProgress.values.last == 1.0)
        #expect(coalescingProgress.values.isEmpty, "the coalescing caller receives none")
    }

    private func makeRepository(
        remote: MockTVListingsRemoteDataSource,
        local: MockTVListingsLocalDataSource
    ) -> DefaultTVListingsSyncRepository {
        DefaultTVListingsSyncRepository(
            remoteDataSource: remote,
            localDataSource: local,
            syncThrottle: 12 * 60 * 60,
            now: { Date(timeIntervalSince1970: 1_000_000) }
        )
    }

}

/// Thread-safe collector for the `@Sendable` progress callback.
private final class ProgressRecorder: Sendable {

    private let storage = Mutex<[Float]>([])

    var values: [Float] {
        storage.withLock { $0 }
    }

    func append(_ value: Float) {
        storage.withLock { $0.append(value) }
    }

}
