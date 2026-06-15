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

    var fetchChannelsStub: Result<[TVChannel], TVListingsRemoteDataSourceError> = .success([])

    var fetchRegionsStub: Result<[TVRegion], TVListingsRemoteDataSourceError> = .success([])

    /// Per-date schedule stubs; falls back to `fetchScheduleDefaultStub` when a date is absent.
    var fetchScheduleStubs: [String: Result<[TVProgramme], TVListingsRemoteDataSourceError>] = [:]
    var fetchScheduleDefaultStub: Result<[TVProgramme], TVListingsRemoteDataSourceError> = .success([])

    /// Optional hook awaited inside `fetchManifest` — lets a test gate the manifest fetch to
    /// exercise overlapping/coalesced syncs deterministically.
    var onFetchManifest: (@Sendable () async -> Void)?

    // Schedule fetches (and, via coalescing, other calls) can run concurrently when the
    // repository fans them out, so all recorded counters/dates are guarded by one lock.
    // Schedule order is not deterministic — assert membership, not sequence.
    private let lock = NSLock()
    private var manifestCalls = 0
    private var channelsCalls = 0
    private var regionsCalls = 0
    private var recordedScheduleDates: [String] = []

    var fetchManifestCallCount: Int {
        lock.withLock { manifestCalls }
    }

    var fetchChannelsCallCount: Int {
        lock.withLock { channelsCalls }
    }

    var fetchRegionsCallCount: Int {
        lock.withLock { regionsCalls }
    }

    var fetchScheduleCalledWith: [String] {
        lock.withLock { recordedScheduleDates }
    }

    func fetchManifest() async throws(TVListingsRemoteDataSourceError) -> EPGManifest {
        lock.withLock { manifestCalls += 1 }
        if let onFetchManifest {
            await onFetchManifest()
        }
        switch fetchManifestStub {
        case .success(let manifest): return manifest
        case .failure(let error): throw error
        }
    }

    func fetchChannels() async throws(TVListingsRemoteDataSourceError) -> [TVChannel] {
        lock.withLock { channelsCalls += 1 }
        switch fetchChannelsStub {
        case .success(let channels): return channels
        case .failure(let error): throw error
        }
    }

    func fetchRegions() async throws(TVListingsRemoteDataSourceError) -> [TVRegion] {
        lock.withLock { regionsCalls += 1 }
        switch fetchRegionsStub {
        case .success(let regions): return regions
        case .failure(let error): throw error
        }
    }

    func fetchSchedule(
        forDate date: String
    ) async throws(TVListingsRemoteDataSourceError) -> [TVProgramme] {
        let result = lock.withLock {
            recordedScheduleDates.append(date)
            return fetchScheduleStubs[date] ?? fetchScheduleDefaultStub
        }
        switch result {
        case .success(let programmes): return programmes
        case .failure(let error): throw error
        }
    }

}
