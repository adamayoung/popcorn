//
//  MockTVProgrammeRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class MockTVProgrammeRepository: TVProgrammeRepository, @unchecked Sendable {

    var programmesCallCount = 0
    var programmesCalledWith: [(channelID: String, date: Date)] = []
    var programmesStub: Result<[TVProgramme], TVListingsRepositoryError> = .success([])

    var nowPlayingCallCount = 0
    var nowPlayingCalledWith: [Date] = []
    var nowPlayingStub: Result<[TVProgramme], TVListingsRepositoryError> = .success([])

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsRepositoryError) -> [TVProgramme] {
        programmesCallCount += 1
        programmesCalledWith.append((channelID, date))

        switch programmesStub {
        case .success(let programmes):
            return programmes
        case .failure(let error):
            throw error
        }
    }

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsRepositoryError) -> [TVProgramme] {
        nowPlayingCallCount += 1
        nowPlayingCalledWith.append(date)

        switch nowPlayingStub {
        case .success(let programmes):
            return programmes
        case .failure(let error):
            throw error
        }
    }

}
