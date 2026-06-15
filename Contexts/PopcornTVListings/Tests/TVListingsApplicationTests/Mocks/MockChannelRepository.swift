//
//  MockChannelRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class MockChannelRepository: ChannelRepository, @unchecked Sendable {

    var channelsCallCount = 0
    var channelsStub: Result<[Channel], TVListingsRepositoryError> = .success([])

    func channels() async throws(TVListingsRepositoryError) -> [Channel] {
        channelsCallCount += 1

        switch channelsStub {
        case .success(let channels):
            return channels
        case .failure(let error):
            throw error
        }
    }

}
