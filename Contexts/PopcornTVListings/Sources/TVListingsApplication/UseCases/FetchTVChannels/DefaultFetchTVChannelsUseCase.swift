//
//  DefaultFetchTVChannelsUseCase.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

final class DefaultFetchTVChannelsUseCase: FetchTVChannelsUseCase {

    private let tvChannelRepository: any TVChannelRepository

    init(tvChannelRepository: some TVChannelRepository) {
        self.tvChannelRepository = tvChannelRepository
    }

    func execute() async throws(FetchTVChannelsError) -> [TVChannel] {
        do {
            return try await tvChannelRepository.channels()
        } catch let error {
            throw FetchTVChannelsError(error)
        }
    }

}
