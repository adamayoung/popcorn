//
//  DefaultTVProgrammeRepositoryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsInfrastructure

@Suite("DefaultTVProgrammeRepository")
struct DefaultTVProgrammeRepositoryTests {

    @Test("programmes returns local data source result")
    func programmesReturnsLocalDataSourceResult() async throws {
        let mockLocal = MockTVListingsLocalDataSource()
        let expected = [TVProgramme.mock(channelID: "BBC")]
        await mockLocal.setProgrammesStub(.success(expected))

        let repository = DefaultTVProgrammeRepository(localDataSource: mockLocal)

        let result = try await repository.programmes(forChannelID: "BBC", onDate: .now)

        #expect(result == expected)
    }

    @Test("programmes translates persistence error to local")
    func programmesTranslatesPersistenceErrorToLocal() async {
        let mockLocal = MockTVListingsLocalDataSource()
        await mockLocal.setProgrammesStub(.failure(.persistence(NSError(domain: "t", code: 1))))

        let repository = DefaultTVProgrammeRepository(localDataSource: mockLocal)

        await #expect(
            performing: {
                _ = try await repository.programmes(forChannelID: "BBC", onDate: .now)
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

    @Test("nowPlayingProgrammes returns local data source result")
    func nowPlayingReturnsLocalDataSourceResult() async throws {
        let mockLocal = MockTVListingsLocalDataSource()
        let expected = [TVProgramme.mock(channelID: "BBC")]
        await mockLocal.setNowPlayingStub(.success(expected))

        let repository = DefaultTVProgrammeRepository(localDataSource: mockLocal)

        let result = try await repository.nowPlayingProgrammes(at: .now)

        #expect(result == expected)
    }

    @Test("nowPlayingProgrammes translates persistence error to local")
    func nowPlayingTranslatesPersistenceErrorToLocal() async {
        let mockLocal = MockTVListingsLocalDataSource()
        await mockLocal.setNowPlayingStub(.failure(.persistence(NSError(domain: "t", code: 1))))

        let repository = DefaultTVProgrammeRepository(localDataSource: mockLocal)

        await #expect(
            performing: {
                _ = try await repository.nowPlayingProgrammes(at: .now)
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
