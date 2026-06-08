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
        let channels: [TVChannel]
        do {
            channels = try await tvChannelRepository.channels()
        } catch let error {
            throw FetchTVChannelsError(error)
        }

        return channels.sorted { Self.sortKey(for: $0) < Self.sortKey(for: $1) }
    }

    private static func sortKey(for channel: TVChannel) -> Int {
        // Channel numbers in the UK EPG data are always whole-number strings, so
        // non-integer values are not expected. Any that fail to parse are dropped
        // here and the channel sorts last (alongside genuinely unnumbered channels).
        channel.channelNumbers
            .compactMap { Int($0.channelNumber) }
            .min() ?? .max
    }

}
