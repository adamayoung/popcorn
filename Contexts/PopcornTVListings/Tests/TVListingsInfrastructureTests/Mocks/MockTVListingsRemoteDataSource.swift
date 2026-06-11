//
//  MockTVListingsRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain
@testable import TVListingsInfrastructure

final class MockTVListingsRemoteDataSource: TVListingsRemoteDataSource, @unchecked Sendable {

    var fetchManifestStub: Result<EPGManifest, TVListingsRemoteDataSourceError> =
        .success(EPGManifest(generatedAt: Date(timeIntervalSince1970: 0), dates: [], files: []))
    var fetchManifestCallCount = 0

    var fetchChannelsStub: Result<[TVChannel], TVListingsRemoteDataSourceError> = .success([])
    var fetchChannelsCallCount = 0

    /// Per-date schedule stubs; falls back to `fetchScheduleDefaultStub` when a date is absent.
    var fetchScheduleStubs: [String: Result<[TVProgramme], TVListingsRemoteDataSourceError>] = [:]
    var fetchScheduleDefaultStub: Result<[TVProgramme], TVListingsRemoteDataSourceError> = .success([])

    /// Schedule fetches can run concurrently (the repository fans them out), so guard the
    /// recording with a lock. The order is not deterministic — assert membership, not sequence.
    private let scheduleLock = NSLock()
    private var recordedScheduleDates: [String] = []
    var fetchScheduleCalledWith: [String] {
        scheduleLock.withLock { recordedScheduleDates }
    }

    /// Optional hook awaited inside `fetchManifest` — lets a test gate the manifest fetch to
    /// exercise overlapping/coalesced syncs deterministically.
    var onFetchManifest: (@Sendable () async -> Void)?

    func fetchManifest() async throws(TVListingsRemoteDataSourceError) -> EPGManifest {
        fetchManifestCallCount += 1
        if let onFetchManifest {
            await onFetchManifest()
        }
        switch fetchManifestStub {
        case .success(let manifest): return manifest
        case .failure(let error): throw error
        }
    }

    func fetchChannels() async throws(TVListingsRemoteDataSourceError) -> [TVChannel] {
        fetchChannelsCallCount += 1
        switch fetchChannelsStub {
        case .success(let channels): return channels
        case .failure(let error): throw error
        }
    }

    func fetchSchedule(
        forDate date: String
    ) async throws(TVListingsRemoteDataSourceError) -> [TVProgramme] {
        scheduleLock.withLock { recordedScheduleDates.append(date) }
        switch fetchScheduleStubs[date] ?? fetchScheduleDefaultStub {
        case .success(let programmes): return programmes
        case .failure(let error): throw error
        }
    }

}
