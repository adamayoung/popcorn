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

@Suite("DefaultTVListingsSyncRepository")
struct DefaultTVListingsSyncRepositoryTests {

    @Test("sync fetches remote and replaces local cache")
    func syncFetchesRemoteAndReplacesLocalCache() async throws {
        let mockRemote = MockTVListingsRemoteDataSource()
        let mockLocal = MockTVListingsLocalDataSource()
        let snapshot = TVListingsSnapshot(
            channels: [TVChannel.mock(id: "BBC")],
            programmes: [TVProgramme.mock(channelID: "BBC")]
        )
        mockRemote.fetchListingsStub = .success(snapshot)

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )

        try await repository.sync()

        #expect(mockRemote.fetchListingsCallCount == 1)
        let replaceCount = await mockLocal.replaceAllCallCount
        let replacedChannels = await mockLocal.replaceAllCalledWith.first?.channels
        let replacedProgrammes = await mockLocal.replaceAllCalledWith.first?.programmes
        #expect(replaceCount == 1)
        #expect(replacedChannels == snapshot.channels)
        #expect(replacedProgrammes == snapshot.programmes)
    }

    @Test("sync throws remote when remote data source throws network")
    func syncThrowsRemoteWhenRemoteThrowsNetwork() async {
        let mockRemote = MockTVListingsRemoteDataSource()
        let mockLocal = MockTVListingsLocalDataSource()
        mockRemote.fetchListingsStub = .failure(.network(nil))

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )

        await #expect(
            performing: {
                try await repository.sync()
            },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError else {
                    return false
                }
                if case .remote = repoError {
                    return true
                }
                return false
            }
        )
        let replaceCount = await mockLocal.replaceAllCallCount
        #expect(replaceCount == 0)
    }

    @Test("sync throws remote when remote data source throws decoding")
    func syncThrowsRemoteWhenRemoteThrowsDecoding() async {
        let mockRemote = MockTVListingsRemoteDataSource()
        let mockLocal = MockTVListingsLocalDataSource()
        mockRemote.fetchListingsStub = .failure(.decoding(nil))

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )

        await #expect(
            performing: {
                try await repository.sync()
            },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError else {
                    return false
                }
                if case .remote = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("sync throws local when local replaceAll fails")
    func syncThrowsLocalWhenReplaceAllFails() async {
        let mockRemote = MockTVListingsRemoteDataSource()
        let mockLocal = MockTVListingsLocalDataSource()
        mockRemote.fetchListingsStub = .success(TVListingsSnapshot(channels: [], programmes: []))
        await mockLocal.setReplaceAllStub(.failure(.persistence(NSError(domain: "t", code: 1))))

        let repository = DefaultTVListingsSyncRepository(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal
        )

        await #expect(
            performing: {
                try await repository.sync()
            },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError else {
                    return false
                }
                if case .local = repoError {
                    return true
                }
                return false
            }
        )
    }

}
