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

        // Explicit tie-break by name then id makes ordering deterministic for channels that share a channel number.
        return channels
            .map { (channel: $0, sortKey: Self.sortKey(for: $0)) }
            .sorted { lhs, rhs in
                if lhs.sortKey != rhs.sortKey {
                    return lhs.sortKey < rhs.sortKey
                }
                let nameOrder = lhs.channel.name.localizedCaseInsensitiveCompare(rhs.channel.name)
                if nameOrder != .orderedSame {
                    return nameOrder == .orderedAscending
                }
                return lhs.channel.id < rhs.channel.id
            }
            .map(\.channel)
    }

    private static func sortKey(for channel: TVChannel) -> Int {
        // Non-parseable channel numbers (e.g. "HD") are excluded; the channel sorts last alongside unnumbered ones.
        channel.channelNumbers
            .compactMap { Int($0.channelNumber) }
            .min() ?? .max
    }

}
