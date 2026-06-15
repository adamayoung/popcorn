//
//  DefaultTVListingsSyncRepositoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("DefaultTVListingsSyncRepository sync")
struct DefaultTVListingsSyncRepositoryTests {

    @Test("sync fetches changed channels and schedules and stamps completion")
    func syncFetchesChangedFilesAndStampsCompletion() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: "c1", scheduleHashes: ["20260611": "s1"])
        )
        remote.fetchChannelsStub = .success([TVChannel.mock(id: "BBC")])
        remote.fetchScheduleStubs["20260611"] = .success([TVProgramme.mock(channelID: "BBC")])

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(remote.fetchChannelsCallCount == 1)
        #expect(remote.fetchScheduleCalledWith == ["20260611"])
        let upserts = await local.upsertChannelsCalls
        let replaces = await local.replaceProgrammesCalls
        let deletes = await local.deleteProgrammesCalls
        let completes = await local.completeSyncCalls
        #expect(upserts.first?.hash == "c1")
        #expect(replaces.first?.hash == "s1")
        #expect(deletes == [["20260611"]])
        #expect(completes.count == 1)
        #expect(completes.first?.paths == Set(["channels.json", "schedules/20260611.json"]))
    }

    @Test("sync skips files whose stored hash matches the manifest")
    func syncSkipsUnchangedFiles() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(
                dates: ["20260611", "20260612"],
                channelsHash: "c1",
                scheduleHashes: ["20260611": "s1", "20260612": "s2"]
            )
        )
        // Stored: channels + day 1 unchanged; day 2 changed.
        await local.setFileStatesStub(.success([
            "channels.json": "c1",
            "schedules/20260611.json": "s1",
            "schedules/20260612.json": "OLD"
        ]))
        remote.fetchScheduleStubs["20260612"] = .success([TVProgramme.mock(channelID: "BBC")])

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(remote.fetchChannelsCallCount == 0, "channels unchanged → not fetched")
        #expect(remote.fetchScheduleCalledWith == ["20260612"], "only the changed day is fetched")
        let replaces = await local.replaceProgrammesCalls
        #expect(replaces.map(\.date) == ["20260612"])
    }

    @Test("sync fetches and persists every changed day (fanned out in parallel)")
    func syncFetchesEveryChangedDay() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        let dates = ["20260611", "20260612", "20260613"]
        remote.fetchManifestStub = .success(
            .mock(
                dates: dates,
                channelsHash: nil,
                scheduleHashes: ["20260611": "s1", "20260612": "s2", "20260613": "s3"]
            )
        )
        for date in dates {
            remote.fetchScheduleStubs[date] = .success([TVProgramme.mock(channelID: "BBC", title: date)])
        }

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(Set(remote.fetchScheduleCalledWith) == Set(dates))
        let replacedDates = await Set(local.replaceProgrammesCalls.map(\.date))
        #expect(replacedDates == Set(dates))
    }

    @Test("sync skips malformed manifest dates instead of requesting them")
    func syncSkipsMalformedDates() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(
                dates: ["20260611", "../../evil"],
                channelsHash: nil,
                scheduleHashes: ["20260611": "s1", "../../evil": "hax"]
            )
        )
        remote.fetchScheduleDefaultStub = .success([])

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(remote.fetchScheduleCalledWith == ["20260611"], "malformed date is never requested")
    }

    @Test("sync stamps completion even when every file is already up to date")
    func syncStampsCompletionWhenAllFilesCurrent() async throws {
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

        try await repository.sync()

        #expect(remote.fetchChannelsCallCount == 0, "channels unchanged → not fetched")
        #expect(remote.fetchScheduleCalledWith.isEmpty, "no day changed → no schedule fetch")
        let completes = await local.completeSyncCalls
        let deletes = await local.deleteProgrammesCalls
        #expect(completes.count == 1, "still stamps lastSyncedAt so the throttle advances")
        #expect(completes.first?.lastSyncedAt == Date(timeIntervalSince1970: 1_000_000))
        #expect(deletes == [["20260611"]])
    }

    @Test("sync does not mutate the cache when the manifest fetch fails")
    func syncDoesNotMutateOnManifestFailure() async {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .failure(.network(nil))

        let repository = makeRepository(remote: remote, local: local)

        await #expect(throws: TVListingsRepositoryError.self) {
            try await repository.sync()
        }

        let mutations = await local.mutationCount
        let fileStateReads = await local.fileStatesCallCount
        #expect(mutations == 0)
        #expect(fileStateReads == 0, "bails before reading stored hashes")
    }

    @Test("sync maps a schedule fetch failure to a repository error")
    func syncMapsScheduleFailure() async {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: nil, scheduleHashes: ["20260611": "s1"])
        )
        remote.fetchScheduleStubs["20260611"] = .failure(.decoding(nil))

        let repository = makeRepository(remote: remote, local: local)

        await #expect(
            performing: { try await repository.sync() },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError,
                      case .remote = repoError
                else {
                    return false
                }
                return true
            }
        )

        // A failed sync must not stamp `lastSyncedAt`, so the next `syncIfNeeded` retries
        // rather than treating the partial result as a completed sync.
        let completes = await local.completeSyncCalls
        #expect(completes.isEmpty)
    }

    @Test("sync maps a local write failure to a repository error")
    func syncMapsLocalWriteFailure() async {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: nil, scheduleHashes: ["20260611": "s1"])
        )
        remote.fetchScheduleStubs["20260611"] = .success([])
        await local.setReplaceProgrammesStub(.failure(.persistence(NSError(domain: "t", code: 1))))

        let repository = makeRepository(remote: remote, local: local)

        await #expect(
            performing: { try await repository.sync() },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError,
                      case .local = repoError
                else {
                    return false
                }
                return true
            }
        )
    }

    // MARK: - Regions

    @Test("sync fetches changed regions and upserts them, retaining regions.json")
    func syncFetchesChangedRegions() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: "c1", regionsHash: "r1", scheduleHashes: ["20260611": "s1"])
        )
        remote.fetchRegionsStub = .success([
            TVRegion(bouquet: 4101, subBouquet: 1, name: "London", nation: "England", isHD: true)
        ])
        remote.fetchScheduleStubs["20260611"] = .success([TVProgramme.mock(channelID: "BBC")])

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(remote.fetchRegionsCallCount == 1)
        let upserts = await local.upsertRegionsCalls
        #expect(upserts.count == 1)
        #expect(upserts.first?.hash == "r1")
        #expect(upserts.first?.regions.first?.name == "London")
        let completes = await local.completeSyncCalls
        #expect(completes.first?.paths.contains("regions.json") == true)
    }

    @Test("sync skips regions when the stored hash matches the manifest")
    func syncSkipsUnchangedRegions() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: nil, regionsHash: "r1", scheduleHashes: [:])
        )
        await local.setFileStatesStub(.success(["regions.json": "r1"]))

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(remote.fetchRegionsCallCount == 0, "regions unchanged → not fetched")
        let upserts = await local.upsertRegionsCalls
        #expect(upserts.isEmpty)
    }

    @Test("sync does not fetch regions when the manifest has no regions file")
    func syncSkipsRegionsWhenAbsentFromManifest() async throws {
        let remote = MockTVListingsRemoteDataSource()
        let local = MockTVListingsLocalDataSource()
        remote.fetchManifestStub = .success(
            .mock(dates: ["20260611"], channelsHash: "c1", scheduleHashes: ["20260611": "s1"])
        )
        remote.fetchChannelsStub = .success([TVChannel.mock(id: "BBC")])
        remote.fetchScheduleStubs["20260611"] = .success([TVProgramme.mock(channelID: "BBC")])

        let repository = makeRepository(remote: remote, local: local)

        try await repository.sync()

        #expect(remote.fetchRegionsCallCount == 0)
        let upserts = await local.upsertRegionsCalls
        #expect(upserts.isEmpty)
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
