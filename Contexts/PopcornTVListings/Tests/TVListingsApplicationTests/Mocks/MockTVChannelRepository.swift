//
//  MockTVChannelRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class MockTVChannelRepository: TVChannelRepository, @unchecked Sendable {

    var channelsCallCount = 0
    var channelsStub: Result<[TVChannel], TVListingsRepositoryError> = .success([])

    func channels() async throws(TVListingsRepositoryError) -> [TVChannel] {
        channelsCallCount += 1

        switch channelsStub {
        case .success(let channels):
            return channels
        case .failure(let error):
            throw error
        }
    }

}
