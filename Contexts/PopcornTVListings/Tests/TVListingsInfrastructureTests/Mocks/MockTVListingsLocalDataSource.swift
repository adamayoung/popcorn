//
//  MockTVListingsLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain
@testable import TVListingsInfrastructure

actor MockTVListingsLocalDataSource: TVListingsLocalDataSource {

    // MARK: - Read stubs

    var channelsStub: Result<[TVChannel], TVListingsLocalDataSourceError> = .success([])
    var programmesStub: Result<[TVProgramme], TVListingsLocalDataSourceError> = .success([])
    var nowPlayingStub: Result<[TVProgramme], TVListingsLocalDataSourceError> = .success([])
    var programmesFromToStub: Result<[TVProgramme], TVListingsLocalDataSourceError> = .success([])
    var fileStatesStub: Result<[String: String], TVListingsLocalDataSourceError> = .success([:])
    var lastSyncedAtStub: Result<Date?, TVListingsLocalDataSourceError> = .success(nil)

    // MARK: - Write stubs

    var upsertChannelsStub: Result<Void, TVListingsLocalDataSourceError> = .success(())
    var replaceProgrammesStub: Result<Void, TVListingsLocalDataSourceError> = .success(())
    var deleteProgrammesStub: Result<Void, TVListingsLocalDataSourceError> = .success(())
    var completeSyncStub: Result<Void, TVListingsLocalDataSourceError> = .success(())

    // MARK: - Recorded calls

    var fileStatesCallCount = 0
    var lastSyncedAtCallCount = 0
    var programmesFromToCalledWith: [(from: Date, to: Date)] = []
    var upsertChannelsCalls: [(channels: [TVChannel], hash: String)] = []
    var replaceProgrammesCalls: [(programmes: [TVProgramme], date: String, hash: String)] = []
    var deleteProgrammesCalls: [[String]] = []
    var completeSyncCalls: [(lastSyncedAt: Date, paths: Set<String>)] = []

    /// Total number of mutating calls — used to assert "no local mutation on failure".
    var mutationCount: Int {
        upsertChannelsCalls.count + replaceProgrammesCalls.count
            + deleteProgrammesCalls.count + completeSyncCalls.count
    }

    // MARK: - Setters (actor properties can't be assigned cross-actor)

    func setFileStatesStub(_ stub: Result<[String: String], TVListingsLocalDataSourceError>) {
        fileStatesStub = stub
    }

    func setLastSyncedAtStub(_ stub: Result<Date?, TVListingsLocalDataSourceError>) {
        lastSyncedAtStub = stub
    }

    func setReplaceProgrammesStub(_ stub: Result<Void, TVListingsLocalDataSourceError>) {
        replaceProgrammesStub = stub
    }

    func setUpsertChannelsStub(_ stub: Result<Void, TVListingsLocalDataSourceError>) {
        upsertChannelsStub = stub
    }

    func setProgrammesFromToStub(_ stub: Result<[TVProgramme], TVListingsLocalDataSourceError>) {
        programmesFromToStub = stub
    }

    // MARK: - Reads

    func channels() async throws(TVListingsLocalDataSourceError) -> [TVChannel] {
        switch channelsStub {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        switch programmesStub {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        switch nowPlayingStub {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    func programmes(
        from start: Date,
        to end: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        programmesFromToCalledWith.append((start, end))
        switch programmesFromToStub {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    func fileStates() async throws(TVListingsLocalDataSourceError) -> [String: String] {
        fileStatesCallCount += 1
        switch fileStatesStub {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    func lastSyncedAt() async throws(TVListingsLocalDataSourceError) -> Date? {
        lastSyncedAtCallCount += 1
        switch lastSyncedAtStub {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    // MARK: - Writes

    func upsertChannels(
        _ channels: [TVChannel],
        hash: String
    ) async throws(TVListingsLocalDataSourceError) {
        upsertChannelsCalls.append((channels, hash))
        switch upsertChannelsStub {
        case .success: return
        case .failure(let error): throw error
        }
    }

    func replaceProgrammes(
        _ programmes: [TVProgramme],
        forDate date: String,
        hash: String
    ) async throws(TVListingsLocalDataSourceError) {
        replaceProgrammesCalls.append((programmes, date, hash))
        switch replaceProgrammesStub {
        case .success: return
        case .failure(let error): throw error
        }
    }

    func deleteProgrammes(
        notInDates dates: [String]
    ) async throws(TVListingsLocalDataSourceError) {
        deleteProgrammesCalls.append(dates)
        switch deleteProgrammesStub {
        case .success: return
        case .failure(let error): throw error
        }
    }

    func completeSync(
        lastSyncedAt date: Date,
        keepingFileStatePaths paths: Set<String>
    ) async throws(TVListingsLocalDataSourceError) {
        completeSyncCalls.append((date, paths))
        switch completeSyncStub {
        case .success: return
        case .failure(let error): throw error
        }
    }

}
