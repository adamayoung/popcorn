//
//  DefaultTVChannelRepositoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("DefaultTVChannelRepository")
struct DefaultTVChannelRepositoryTests {

    @Test("channels returns local data source result")
    func channelsReturnsLocalDataSourceResult() async throws {
        let mockLocal = MockTVListingsLocalDataSource()
        let expected = [TVChannel.mock(id: "BBC"), TVChannel.mock(id: "ITV")]
        await mockLocal.setChannelsStub(.success(expected))

        let repository = DefaultTVChannelRepository(localDataSource: mockLocal)

        let result = try await repository.channels()

        #expect(result == expected)
    }

    @Test("channels translates persistence error to local")
    func channelsTranslatesPersistenceErrorToLocal() async {
        let mockLocal = MockTVListingsLocalDataSource()
        let underlying = NSError(domain: "test", code: 1)
        await mockLocal.setChannelsStub(.failure(.persistence(underlying)))

        let repository = DefaultTVChannelRepository(localDataSource: mockLocal)

        await #expect(
            performing: {
                _ = try await repository.channels()
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

    @Test("channels translates unknown error to unknown")
    func channelsTranslatesUnknownErrorToUnknown() async {
        let mockLocal = MockTVListingsLocalDataSource()
        await mockLocal.setChannelsStub(.failure(.unknown(nil)))

        let repository = DefaultTVChannelRepository(localDataSource: mockLocal)

        await #expect(
            performing: {
                _ = try await repository.channels()
            },
            throws: { error in
                guard let repoError = error as? TVListingsRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

}

// MARK: - Stub helpers

extension MockTVListingsLocalDataSource {

    func setChannelsStub(_ value: Result<[TVChannel], TVListingsLocalDataSourceError>) {
        channelsStub = value
    }

    func setProgrammesStub(_ value: Result<[TVProgramme], TVListingsLocalDataSourceError>) {
        programmesStub = value
    }

    func setNowPlayingStub(_ value: Result<[TVProgramme], TVListingsLocalDataSourceError>) {
        nowPlayingStub = value
    }

    func setReplaceAllStub(_ value: Result<Void, TVListingsLocalDataSourceError>) {
        replaceAllStub = value
    }

}
